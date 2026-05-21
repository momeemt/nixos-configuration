#!/usr/bin/env bash
set -Eeuo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: $0 <attic-cache> <nix-build-out-paths-file>" >&2
  exit 2
fi

cache_name="$1"
out_paths_file="$2"

diag_dir="${ATTIC_DIAG_DIR:-${RUNNER_TEMP:-/tmp}/attic-diagnostics}"
closure_paths_file="$diag_dir/closure-paths.txt"
attic_jobs="${ATTIC_PUSH_JOBS:-1}"
monitor_interval="${ATTIC_DIAG_INTERVAL_SECONDS:-15}"
monitor_pid=""

mkdir -p "$diag_dir"

timestamp() {
  date -u '+%Y-%m-%dT%H:%M:%SZ'
}

log() {
  printf '%s %s\n' "$(timestamp)" "$*"
}

begin_group() {
  if [[ "${GITHUB_ACTIONS:-}" == "true" ]]; then
    printf '::group::%s\n' "$*"
  else
    log "$*"
  fi
}

end_group() {
  if [[ "${GITHUB_ACTIONS:-}" == "true" ]]; then
    printf '::endgroup::\n'
  fi
}

run_optional() {
  log "+ $*"
  "$@" || true
}

snapshot() {
  local label="$1"

  begin_group "Attic diagnostics snapshot: $label"
  log "label=$label"
  log "runner_os=${RUNNER_OS:-unknown} image_os=${ImageOS:-unknown} image_version=${ImageVersion:-unknown}"
  log "github_run_id=${GITHUB_RUN_ID:-unknown} github_job=${GITHUB_JOB:-unknown} github_run_attempt=${GITHUB_RUN_ATTEMPT:-unknown}"
  run_optional uname -a
  if command -v sw_vers >/dev/null 2>&1; then
    run_optional sw_vers
  fi
  if command -v nproc >/dev/null 2>&1; then
    run_optional nproc
  fi
  if command -v sysctl >/dev/null 2>&1; then
    run_optional sysctl -n hw.memsize
  fi
  run_optional ulimit -a
  run_optional df -h
  run_optional df -ih
  if command -v free >/dev/null 2>&1; then
    run_optional free -h
  fi
  if command -v vm_stat >/dev/null 2>&1; then
    run_optional vm_stat
  fi
  if command -v nix >/dev/null 2>&1; then
    run_optional nix --version
  fi
  if command -v attic >/dev/null 2>&1; then
    run_optional attic --version
  fi
  log "+ ps top by cpu"
  ps -axo pid,ppid,%cpu,%mem,rss,vsz,command | sort -k3 -nr | head -n 25 || true
  log "+ ps top by rss"
  ps -axo pid,ppid,%cpu,%mem,rss,vsz,command | sort -k5 -nr | head -n 25 || true
  end_group
}

monitor() {
  while true; do
    begin_group "Attic diagnostics monitor"
    log "monitor_interval_seconds=$monitor_interval"
    run_optional df -h
    if command -v free >/dev/null 2>&1; then
      run_optional free -h
    elif command -v vm_stat >/dev/null 2>&1; then
      run_optional vm_stat
    fi
    log "+ ps top by rss"
    ps -axo pid,ppid,%cpu,%mem,rss,vsz,command | sort -k5 -nr | head -n 10 || true
    end_group
    sleep "$monitor_interval"
  done
}

stop_monitor() {
  if [[ -n "$monitor_pid" ]] && kill -0 "$monitor_pid" 2>/dev/null; then
    kill "$monitor_pid" 2>/dev/null || true
    wait "$monitor_pid" 2>/dev/null || true
  fi
}

on_signal() {
  local signal="$1"
  log "received signal=$signal while running Attic diagnostics"
  snapshot "signal-$signal"
  stop_monitor
  exit 143
}

trap 'on_signal TERM' TERM
trap 'on_signal INT' INT
trap 'stop_monitor' EXIT

collect_closure_paths() {
  if [[ ! -s "$out_paths_file" ]]; then
    log "nix build output path file is empty: $out_paths_file"
    exit 2
  fi

  : >"$closure_paths_file"

  begin_group "Attic diagnostics: collect closure paths"
  while IFS= read -r out_path; do
    [[ -z "$out_path" ]] && continue
    log "output_path=$out_path"
    nix path-info --recursive "$out_path" >>"$closure_paths_file"
  done <"$out_paths_file"

  sort -u -o "$closure_paths_file" "$closure_paths_file"

  local closure_count
  closure_count="$(wc -l <"$closure_paths_file" | tr -d '[:space:]')"
  log "closure_path_count=$closure_count"

  if command -v jq >/dev/null 2>&1; then
    local index=0
    while IFS= read -r out_path; do
      [[ -z "$out_path" ]] && continue
      local json_file="$diag_dir/path-info-$index.json"
      if nix path-info --recursive --json "$out_path" >"$json_file"; then
        jq -r '
          to_entries as $entries
          | ($entries | length) as $count
          | ($entries | map(.value.narSize // 0) | add // 0) as $nar
          | ($entries | map(.value.closureSize // 0) | max // 0) as $maxClosure
          | "json_path_count=\($count) total_nar_bytes=\($nar) max_closure_bytes=\($maxClosure)"
        ' "$json_file" || true
        log "top_nar_sizes_for_output=$out_path"
        jq -r '
          to_entries
          | sort_by(.value.narSize // 0)
          | reverse
          | .[:30][]
          | "\(.value.narSize // 0)\t\(.key)"
        ' "$json_file" | {
          if command -v numfmt >/dev/null 2>&1; then
            numfmt --field=1 --to=iec --suffix=B
          else
            cat
          fi
        } || true
      fi
      index="$((index + 1))"
    done <"$out_paths_file"
  else
    log "jq is not available; skipping JSON size summary"
  fi
  end_group
}

write_step_summary() {
  [[ -n "${GITHUB_STEP_SUMMARY:-}" ]] || return 0

  local closure_count
  closure_count="$(wc -l <"$closure_paths_file" | tr -d '[:space:]')"

  {
    echo "### Attic push diagnostics"
    echo
    echo "- Target: \`${MATRIX_TARGET:-unknown}\`"
    echo "- Attic jobs: \`$attic_jobs\`"
    echo "- Closure paths: \`$closure_count\`"
    echo "- Diagnostics dir: \`$diag_dir\`"
  } >>"$GITHUB_STEP_SUMMARY"
}

main() {
  log "starting Attic push diagnostics"
  log "cache_name_is_masked_by_github_actions_if_secret=$cache_name"
  log "out_paths_file=$out_paths_file"
  log "diag_dir=$diag_dir"
  log "attic_jobs=$attic_jobs"

  snapshot "before-closure-collection"
  collect_closure_paths
  write_step_summary
  snapshot "before-attic-push"

  monitor &
  monitor_pid="$!"
  log "monitor_pid=$monitor_pid"

  local status
  set +e
  attic push --stdin --no-closure -j "$attic_jobs" "$cache_name" <"$closure_paths_file"
  status="$?"
  set -e

  log "attic_push_exit_status=$status"
  stop_monitor
  snapshot "after-attic-push-status-$status"

  return "$status"
}

main
