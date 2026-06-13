# shellcheck disable=SC2148

set -euo pipefail

base_url="${TOGGL_FOCUS_BASE_URL:-https://focus.toggl.com/api}"

usage() {
  cat <<'EOF'
Usage:
  toggl-openclaw settings
  toggl-openclaw current
  toggl-openclaw start [options] <description>
  toggl-openclaw stop
  toggl-openclaw list-today
  toggl-openclaw list-range <date_from> <date_to>

Options for start:
  --start <rfc3339>
  --project-id <id>
  --task-id <id>
  --billable <true|false>
  --type <activity|break>

Environment:
  TOGGL_API_TOKEN          Toggl 2.0 / Focus API key.
  TOGGL_API_TOKEN_FILE     File containing the API key.
  TOGGL_ORGANIZATION_ID    Toggl 2.0 organization ID.
  TOGGL_WORKSPACE_ID       Toggl 2.0 workspace ID. If absent, current_workspace_id
                           is read from /users/me/settings.
  TOGGL_TIMEZONE           Timezone for list-today. Defaults to Asia/Tokyo.
EOF
}

die() {
  echo "toggl-openclaw: $*" >&2
  exit 1
}

read_token() {
  if [[ -n "${TOGGL_API_TOKEN_FILE:-}" ]]; then
    [[ -r "$TOGGL_API_TOKEN_FILE" ]] || die "TOGGL_API_TOKEN_FILE is not readable: $TOGGL_API_TOKEN_FILE"
    tr -d '\r\n' <"$TOGGL_API_TOKEN_FILE"
    return
  fi

  if [[ -n "${TOGGL_API_TOKEN:-}" && -f "${TOGGL_API_TOKEN:-}" ]]; then
    tr -d '\r\n' <"$TOGGL_API_TOKEN"
    return
  fi

  [[ -n "${TOGGL_API_TOKEN:-}" ]] || die "TOGGL_API_TOKEN or TOGGL_API_TOKEN_FILE is required"
  printf '%s' "$TOGGL_API_TOKEN" | tr -d '\r\n'
}

urlencode() {
  jq -rn --arg value "$1" '$value | @uri'
}

request() {
  local method="$1"
  local path="$2"
  local body="${3-}"
  local tmp
  local status
  local token

  token="$(read_token)"

  tmp="$(mktemp)"
  if [[ -n "$body" ]]; then
    status="$(
      curl -sS -o "$tmp" -w '%{http_code}' \
        -X "$method" \
        -H "Authorization: Bearer $token" \
        -H 'Content-Type: application/json' \
        --data "$body" \
        "${base_url}${path}"
    )"
  else
    status="$(
      curl -sS -o "$tmp" -w '%{http_code}' \
        -X "$method" \
        -H "Authorization: Bearer $token" \
        -H 'Content-Type: application/json' \
        "${base_url}${path}"
    )"
  fi

  if [[ "$status" =~ ^2[0-9][0-9]$ ]]; then
    cat "$tmp"
    rm -f "$tmp"
    return 0
  fi

  echo "toggl-openclaw: HTTP $status for $method $path" >&2
  cat "$tmp" >&2
  rm -f "$tmp"
  return 1
}

settings() {
  request GET "/users/me/settings"
}

workspace_id() {
  if [[ -n "${TOGGL_WORKSPACE_ID:-}" ]]; then
    printf '%s' "$TOGGL_WORKSPACE_ID"
    return
  fi

  local workspace
  workspace="$(settings | jq -r '.current_workspace_id // empty')"
  [[ -n "$workspace" ]] || die "TOGGL_WORKSPACE_ID is required and /users/me/settings did not return current_workspace_id"
  printf '%s' "$workspace"
}

organization_id() {
  [[ -n "${TOGGL_ORGANIZATION_ID:-}" ]] || die "TOGGL_ORGANIZATION_ID is required for Toggl 2.0 tracking endpoints"
  printf '%s' "$TOGGL_ORGANIZATION_ID"
}

tracking_path() {
  local action="$1"
  printf '/organizations/%s/workspaces/%s/tracking/%s' "$(organization_id)" "$(workspace_id)" "$action"
}

time_entries_path() {
  local from="$1"
  local to="$2"
  printf '/organizations/%s/workspaces/%s/time-entries?date_from=%s&date_to=%s&include_taskless=true&per_page=100&order_by=start' \
    "$(organization_id)" \
    "$(workspace_id)" \
    "$(urlencode "$from")" \
    "$(urlencode "$to")"
}

current() {
  local output
  if output="$(request GET "$(tracking_path current)")"; then
    if [[ -z "$output" ]]; then
      jq -nc '{running:false}'
    else
      jq -c '. + {running:true}' <<<"$output"
    fi
  fi
}

start() {
  local entry_type="activity"
  local start_at=""
  local project_id=""
  local task_id=""
  local billable=""
  local args=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
    --type)
      entry_type="${2:-}"
      shift 2
      ;;
    --start)
      start_at="${2:-}"
      shift 2
      ;;
    --project-id)
      project_id="${2:-}"
      shift 2
      ;;
    --task-id)
      task_id="${2:-}"
      shift 2
      ;;
    --billable)
      billable="${2:-}"
      shift 2
      ;;
    --)
      shift
      args+=("$@")
      break
      ;;
    -*)
      die "unknown start option: $1"
      ;;
    *)
      args+=("$1")
      shift
      ;;
    esac
  done

  [[ "$entry_type" == "activity" || "$entry_type" == "break" ]] || die "--type must be activity or break"
  [[ ${#args[@]} -gt 0 ]] || die "start requires a description"

  local description="${args[*]}"
  if [[ -z "$start_at" ]]; then
    start_at="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  fi

  local payload
  payload="$(jq -nc \
    --arg type "$entry_type" \
    --arg start "$start_at" \
    --arg description "$description" \
    '{type:$type,start:$start,description:$description}')"

  if [[ -n "$project_id" ]]; then
    payload="$(jq -c --argjson project_id "$project_id" '. + {project_id:$project_id}' <<<"$payload")"
  fi
  if [[ -n "$task_id" ]]; then
    payload="$(jq -c --argjson task_id "$task_id" '. + {task_id:$task_id}' <<<"$payload")"
  fi
  if [[ -n "$billable" ]]; then
    [[ "$billable" == "true" || "$billable" == "false" ]] || die "--billable must be true or false"
    payload="$(jq -c --argjson billable "$billable" '. + {billable:$billable}' <<<"$payload")"
  fi

  request POST "$(tracking_path start)" "$payload"
}

stop() {
  local end_at="${1:-}"
  if [[ -z "$end_at" ]]; then
    end_at="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  fi

  local payload
  payload="$(jq -nc --arg end "$end_at" '{end:$end}')"
  request POST "$(tracking_path stop)" "$payload"
}

list_today() {
  local tz="${TOGGL_TIMEZONE:-Asia/Tokyo}"
  local from
  local to
  from="$(TZ="$tz" date --iso-8601=seconds -d 'today 00:00')"
  to="$(TZ="$tz" date --iso-8601=seconds -d 'tomorrow 00:00')"
  request GET "$(time_entries_path "$from" "$to")"
}

list_range() {
  [[ $# -eq 2 ]] || die "list-range requires <date_from> <date_to>"
  request GET "$(time_entries_path "$1" "$2")"
}

cmd="${1:-}"
if [[ -z "$cmd" ]]; then
  usage
  exit 2
fi
shift

case "$cmd" in
settings)
  settings
  ;;
current)
  current
  ;;
start)
  start "$@"
  ;;
stop)
  stop "$@"
  ;;
list-today)
  list_today
  ;;
list-range)
  list_range "$@"
  ;;
-h | --help | help)
  usage
  ;;
*)
  usage >&2
  exit 2
  ;;
esac
