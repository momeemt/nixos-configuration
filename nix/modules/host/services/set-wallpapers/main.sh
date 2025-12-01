# shellcheck disable=SC2148

set -euo pipefail

IFS=":" read -r -a wallpapers <<<"${WALLPAPERS:-}"

if [ "${#wallpapers[@]}" -eq 0 ]; then
  exit 0
fi

state_dir="${HOME}/Library/Application Support/set-wallpapers"
state_file="${state_dir}/current"
mkdir -p "${state_dir}"

if [ -f "${state_file}" ]; then
  last="$(cat "${state_file}")"
else
  last=""
fi

candidates=()
for img in "${wallpapers[@]}"; do
  if [ "${img}" != "${last}" ]; then
    candidates+=("${img}")
  fi
done

if [ "${#candidates[@]}" -eq 0 ]; then
  # All wallpapers have been used last time, reset the list.
  candidates=("${wallpapers[@]}")
fi

next="$(printf '%s\n' "${candidates[@]}" | shuf -n 1)"

/usr/bin/osascript "${SET_APPLESCRIPT}" "${next}"

printf '%s\n' "${next}" >"${state_file}"
