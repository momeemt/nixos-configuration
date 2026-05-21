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
raw_path_sizes_file="$diag_dir/closure-path-sizes.raw.tsv"
path_sizes_file="$diag_dir/closure-path-sizes.tsv"
upload_path_sizes_file="$diag_dir/upload-path-sizes.tsv"
upload_paths_file="$diag_dir/upload-paths.txt"
skipped_path_sizes_file="$diag_dir/skipped-path-sizes.tsv"
attic_jobs="${ATTIC_PUSH_JOBS:-1}"
attic_chunk_target_bytes="${ATTIC_PUSH_CHUNK_TARGET_BYTES:-2147483648}"
attic_max_path_nar_bytes="${ATTIC_PUSH_MAX_PATH_NAR_BYTES:-0}"
attic_exclude_store_regex="${ATTIC_EXCLUDE_STORE_REGEX:-}"
monitor_interval="${ATTIC_DIAG_INTERVAL_SECONDS:-15}"
monitor_pid=""

mkdir -p "$diag_dir"

timestamp() {
  date -u '+%Y-%m-%dT%H:%M:%SZ'
}

log() {
  printf '%s %s\n' "$(timestamp)" "$*"
}

validate_uint() {
  local name="$1"
  local value="$2"

  if [[ -z "$value" || "$value" == *[!0-9]* ]]; then
    log "$name must be an unsigned integer: $value"
    exit 2
  fi
}

count_lines() {
  local file="$1"

  if [[ -f "$file" ]]; then
    wc -l <"$file" | tr -d '[:space:]'
  else
    printf '0\n'
  fi
}

format_bytes() {
  local bytes="$1"

  if command -v numfmt >/dev/null 2>&1; then
    numfmt --to=iec --suffix=B "$bytes"
  else
    printf '%sB\n' "$bytes"
  fi
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
  : >"$raw_path_sizes_file"

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
        jq -r '
          to_entries[]
          | "\(.value.narSize // 0)\t\(.key)"
        ' "$json_file" >>"$raw_path_sizes_file" || true
      fi
      index="$((index + 1))"
    done <"$out_paths_file"
  else
    log "jq is not available; skipping JSON size summary"
  fi

  if [[ -s "$raw_path_sizes_file" ]]; then
    sort -t $'\t' -k2,2 -k1,1nr "$raw_path_sizes_file" |
      awk 'BEGIN { FS = OFS = "\t" } !seen[$2]++ { print $1, $2 }' |
      sort -n >"$path_sizes_file"
  fi
  end_group
}

build_upload_plan() {
  : >"$upload_paths_file"
  : >"$upload_path_sizes_file"
  : >"$skipped_path_sizes_file"

  begin_group "Attic diagnostics: build upload plan"
  log "attic_chunk_target_bytes=$attic_chunk_target_bytes"
  log "attic_max_path_nar_bytes=$attic_max_path_nar_bytes"
  log "attic_exclude_store_regex=${attic_exclude_store_regex:-<unset>}"

  if [[ ! -s "$path_sizes_file" ]]; then
    log "path size data is unavailable; uploading all paths in one chunk"
    cp "$closure_paths_file" "$upload_paths_file"
    awk 'BEGIN { OFS = "\t" } { print 0, $0 }' "$closure_paths_file" >"$upload_path_sizes_file"
  else
    awk -v max="$attic_max_path_nar_bytes" -v regex="$attic_exclude_store_regex" -v skipped="$skipped_path_sizes_file" '
      BEGIN { FS = OFS = "\t" }
      {
        size = $1 + 0
        path = $2
        reason = ""

        if (max > 0 && size > max) {
          reason = "nar-size-over-limit"
        } else if (regex != "" && path ~ regex) {
          reason = "excluded-by-regex"
        }

        if (reason != "") {
          print reason, $1, path >> skipped
        } else {
          print $1, path
        }
      }
    ' "$path_sizes_file" >"$upload_path_sizes_file"
    cut -f2- "$upload_path_sizes_file" >"$upload_paths_file"
  fi

  log "upload_path_count=$(count_lines "$upload_paths_file")"
  log "skipped_path_count=$(count_lines "$skipped_path_sizes_file")"

  if [[ -s "$skipped_path_sizes_file" ]]; then
    log "skipped_paths_top_by_nar_size"
    sort -t $'\t' -k2,2nr "$skipped_path_sizes_file" | awk 'NR <= 20' | while IFS=$'\t' read -r reason size path; do
      log "skip reason=$reason nar_size_bytes=$size nar_size=$(format_bytes "$size") path=$path"
    done
  fi
  end_group
}

write_step_summary() {
  [[ -n "${GITHUB_STEP_SUMMARY:-}" ]] || return 0

  local closure_count upload_count skipped_count
  closure_count="$(count_lines "$closure_paths_file")"
  upload_count="$(count_lines "$upload_paths_file")"
  skipped_count="$(count_lines "$skipped_path_sizes_file")"

  {
    echo "### Attic push diagnostics"
    echo
    echo "- Target: \`${MATRIX_TARGET:-unknown}\`"
    echo "- Attic jobs: \`$attic_jobs\`"
    echo "- Chunk target bytes: \`$attic_chunk_target_bytes\`"
    echo "- Max path NAR bytes: \`$attic_max_path_nar_bytes\`"
    echo "- Closure paths: \`$closure_count\`"
    echo "- Upload paths: \`$upload_count\`"
    echo "- Skipped paths: \`$skipped_count\`"
    echo "- Diagnostics dir: \`$diag_dir\`"
  } >>"$GITHUB_STEP_SUMMARY"
}

push_chunk_file() {
  local chunk_index="$1"
  local chunk_file="$2"
  local chunk_bytes="$3"
  local chunk_count="$4"
  local status

  if [[ "$chunk_count" -eq 0 ]]; then
    return 0
  fi

  log "attic_push_chunk_index=$chunk_index paths=$chunk_count estimated_nar_bytes=$chunk_bytes estimated_nar_size=$(format_bytes "$chunk_bytes")"
  set +e
  attic push --stdin --no-closure -j "$attic_jobs" "$cache_name" <"$chunk_file"
  status="$?"
  set -e
  log "attic_push_chunk_exit_status=$status index=$chunk_index"

  return "$status"
}

push_attic_chunks() {
  if [[ ! -s "$upload_paths_file" ]]; then
    log "no paths selected for Attic push"
    return 0
  fi

  local chunk_dir="$diag_dir/chunks-$$"
  local chunk_index=1
  local chunk_file
  local current_bytes=0
  local current_count=0
  local size path

  mkdir -p "$chunk_dir"
  chunk_file="$chunk_dir/chunk-$(printf '%04d' "$chunk_index").txt"
  : >"$chunk_file"

  while IFS=$'\t' read -r size path; do
    [[ -n "$path" ]] || continue

    if [[ "$current_count" -gt 0 ]] &&
      [[ "$attic_chunk_target_bytes" -gt 0 ]] &&
      [[ "$((current_bytes + size))" -gt "$attic_chunk_target_bytes" ]]; then
      push_chunk_file "$chunk_index" "$chunk_file" "$current_bytes" "$current_count" || return "$?"
      chunk_index="$((chunk_index + 1))"
      chunk_file="$chunk_dir/chunk-$(printf '%04d' "$chunk_index").txt"
      : >"$chunk_file"
      current_bytes=0
      current_count=0
    fi

    printf '%s\n' "$path" >>"$chunk_file"
    current_bytes="$((current_bytes + size))"
    current_count="$((current_count + 1))"
  done <"$upload_path_sizes_file"

  push_chunk_file "$chunk_index" "$chunk_file" "$current_bytes" "$current_count" || return "$?"
}

main() {
  validate_uint ATTIC_PUSH_CHUNK_TARGET_BYTES "$attic_chunk_target_bytes"
  validate_uint ATTIC_PUSH_MAX_PATH_NAR_BYTES "$attic_max_path_nar_bytes"

  log "starting Attic push diagnostics"
  log "cache_name_is_masked_by_github_actions_if_secret=$cache_name"
  log "out_paths_file=$out_paths_file"
  log "diag_dir=$diag_dir"
  log "attic_jobs=$attic_jobs"
  log "attic_chunk_target_bytes=$attic_chunk_target_bytes"
  log "attic_max_path_nar_bytes=$attic_max_path_nar_bytes"

  snapshot "before-closure-collection"
  collect_closure_paths
  build_upload_plan
  write_step_summary
  snapshot "before-attic-push"

  monitor &
  monitor_pid="$!"
  log "monitor_pid=$monitor_pid"

  local status
  if push_attic_chunks; then
    status=0
  else
    status="$?"
  fi

  log "attic_push_exit_status=$status"
  stop_monitor
  snapshot "after-attic-push-status-$status"

  return "$status"
}

main
