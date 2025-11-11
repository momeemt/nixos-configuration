{
  writeShellScriptBin,
  nix,
  coreutils,
  ...
}:
writeShellScriptBin "nix-clean" ''
  set -euo pipefail

  echo "🧹 Cleaning old Nix generations..."
  echo ""

  # Show current generations
  echo "Current generations:"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    nix-env --list-generations --profile /nix/var/nix/profiles/system || true
    darwin-rebuild --list-generations 2>/dev/null || true
  else
    ${nix}/bin/nix-env --list-generations --profile /nix/var/nix/profiles/system || true
  fi
  echo ""

  # Ask for confirmation
  read -p "Delete generations older than 30 days? (y/N) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
      nix-collect-garbage --delete-older-than 30d
    else
      sudo ${nix}/bin/nix-collect-garbage --delete-older-than 30d
    fi
    echo ""
    echo "✅ Old generations deleted!"
  else
    echo "❌ Cancelled."
  fi

  echo ""
  echo "💾 Running garbage collection..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    nix-store --gc
  else
    sudo ${nix}/bin/nix-store --gc
  fi

  echo ""
  echo "✅ Cleanup complete!"
''
