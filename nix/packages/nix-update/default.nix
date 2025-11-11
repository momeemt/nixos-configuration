{
  writeShellScriptBin,
  nix,
  ...
}:
writeShellScriptBin "nix-update" ''
  set -euo pipefail

  echo "🔄 Updating flake.lock..."
  ${nix}/bin/nix flake update --commit-lock-file

  echo "✅ flake.lock updated successfully!"
  echo ""
  echo "Run 'make apply' to apply the updated configuration."
''
