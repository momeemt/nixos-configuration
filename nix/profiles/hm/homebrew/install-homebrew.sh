# shellcheck disable=SC2148

set -euo pipefail

BREW="/opt/homebrew/bin/brew"

if [ ! -x "$BREW" ]; then
  echo "Homebrew not found. Installing Homebrew..."
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew already installed. Skipping."
fi

if [ -z "${BREWFILE:-}" ]; then
  echo "BREWFILE is not set." >&2
  exit 1
fi

if [ ! -f "$BREWFILE" ]; then
  echo "BREWFILE '$BREWFILE' not found." >&2
  exit 1
fi

echo "Installing packages from Brewfile: $BREWFILE"
"$BREW" bundle --file="$BREWFILE"
