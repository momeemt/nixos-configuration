set -euo pipefail

ROOT_DIR="$(pwd)"
SECRETS_DIR="$ROOT_DIR/secrets"
TARGETS=$(find "$SECRETS_DIR" -type f ! -name '*.enc')

echo "[encrypt-secrets] Encrypting secrets in: $SECRETS_DIR"
for file in $TARGETS; do
  [[ "$file" == **/.gitignore ]] && continue
  ENC_FILE="${file}.enc"
  echo "  - encrypting: $file -> $ENC_FILE"
  sops -e "$file" > "$ENC_FILE"
done
echo "[encrypt-secrets] All secrets encrypted!"

