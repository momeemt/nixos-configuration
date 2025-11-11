{
  writeShellScriptBin,
  coreutils,
  git,
  ...
}:
writeShellScriptBin "setup-dev" ''
  set -euo pipefail

  echo "🚀 Setting up NixOS Configuration development environment..."
  echo ""

  # Check if we're in the repository root
  if [ ! -f "flake.nix" ]; then
    echo "❌ Error: Not in repository root (flake.nix not found)"
    exit 1
  fi

  # Create .envrc if it doesn't exist
  if [ ! -f ".envrc" ]; then
    echo "📝 Creating .envrc..."
    ${coreutils}/bin/cp .envrc.example .envrc
    echo "✅ .envrc created. Run 'direnv allow' to activate."
  else
    echo "ℹ️  .envrc already exists"
  fi

  # Setup git hooks
  if command -v pre-commit &> /dev/null; then
    echo "🪝 Setting up pre-commit hooks..."
    pre-commit install
    echo "✅ Pre-commit hooks installed"
  else
    echo "⚠️  pre-commit not found, skipping hooks setup"
    echo "   Run 'nix develop' to enter development shell with pre-commit"
  fi

  echo ""
  echo "✅ Development environment setup complete!"
  echo ""
  echo "Next steps:"
  echo "  1. Run 'direnv allow' (if you have direnv installed)"
  echo "  2. Or run 'nix develop' to enter the development shell"
  echo "  3. Run 'devtools help' to see available commands"
  echo ""
''
