{
  writeShellScriptBin,
  nix,
  coreutils,
  gnumake,
  ...
}:
writeShellScriptBin "quick-switch" ''
  set -euo pipefail

  HOSTNAME=$(${coreutils}/bin/uname -n)

  echo "🚀 Quick switching configuration for: $HOSTNAME"
  echo ""

  # Check if we're in the repository root
  if [ ! -f "flake.nix" ]; then
    echo "❌ Error: Not in repository root (flake.nix not found)"
    exit 1
  fi

  # Format code before switching
  echo "📝 Formatting code..."
  ${nix}/bin/nix fmt || true

  echo ""
  echo "🔄 Applying configuration..."

  # Use the Makefile to apply configuration
  ${gnumake}/bin/make apply

  echo ""
  echo "✅ Configuration applied successfully!"
''
