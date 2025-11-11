{
  writeShellScriptBin,
  nix,
  git,
  gnumake,
  fzf,
  ...
}:
writeShellScriptBin "devtools" ''
  set -euo pipefail

  show_help() {
    cat <<EOF
  🛠️  NixOS Configuration Development Tools

  Usage: devtools <command>

  Commands:
    check       - Run all checks (format, lint, build)
    fmt         - Format all files
    build       - Build all configurations
    test        - Run flake checks
    update      - Update flake.lock
    clean       - Clean old generations
    switch      - Quick switch configuration
    rollback    - Rollback to previous generation
    diff        - Show configuration differences
    generations - List system generations
    help        - Show this help message

  Examples:
    devtools check       # Run all checks before committing
    devtools fmt         # Format all Nix files
    devtools build       # Build all configurations
    devtools switch      # Apply configuration changes
    devtools rollback    # Rollback to previous generation
  EOF
  }

  check_command() {
    echo "🔍 Running all checks..."
    echo ""

    echo "📝 Formatting..."
    ${nix}/bin/nix fmt || {
      echo "❌ Formatting failed!"
      exit 1
    }

    echo ""
    echo "🔎 Linting..."
    ${nix}/bin/nix flake check --show-trace || {
      echo "❌ Flake check failed!"
      exit 1
    }

    echo ""
    echo "✅ All checks passed!"
  }

  build_command() {
    echo "🏗️  Building all configurations..."
    echo ""

    # Try to build each host
    for host in uguisu emu shime oshidori; do
      echo "Building $host..."
      if [[ "$host" == "uguisu" ]]; then
        ${nix}/bin/nix build .#darwinConfigurations.$host.system --show-trace --no-link || {
          echo "❌ Failed to build $host"
          exit 1
        }
      else
        ${nix}/bin/nix build .#nixosConfigurations.$host.config.system.build.toplevel --show-trace --no-link || {
          echo "❌ Failed to build $host"
          exit 1
        }
      fi
      echo "✅ $host built successfully"
      echo ""
    done

    echo "✅ All configurations built successfully!"
  }

  diff_command() {
    echo "📊 Configuration differences..."
    echo ""

    HOSTNAME=$(uname -n)

    if [[ "$OSTYPE" == "darwin"* ]]; then
      ${nix}/bin/nix build .#darwinConfigurations.$HOSTNAME.system --no-link --print-out-paths > /tmp/new-system
      OLD_SYSTEM=$(ls -d /nix/var/nix/profiles/system-*-link 2>/dev/null | tail -n 1)
      if [ -n "$OLD_SYSTEM" ]; then
        ${nix}/bin/nix store diff-closures $OLD_SYSTEM $(cat /tmp/new-system)
      else
        echo "No previous generation found"
      fi
    else
      sudo ${nix}/bin/nix store diff-closures /run/current-system /nix/var/nix/profiles/system || true
    fi
  }

  generations_command() {
    echo "📜 System generations:"
    echo ""

    if [[ "$OSTYPE" == "darwin"* ]]; then
      ls -lt /nix/var/nix/profiles/system-*-link 2>/dev/null | head -10 || echo "No generations found"
    else
      sudo ${nix}/bin/nix-env --list-generations --profile /nix/var/nix/profiles/system
    fi
  }

  case "''${1:-help}" in
    check)
      check_command
      ;;
    fmt)
      ${nix}/bin/nix fmt
      ;;
    build)
      build_command
      ;;
    test)
      ${nix}/bin/nix flake check --show-trace
      ;;
    update)
      ${nix}/bin/nix flake update --commit-lock-file
      ;;
    clean)
      ${nix}/bin/nix run .#nix-clean
      ;;
    switch)
      ${nix}/bin/nix run .#quick-switch
      ;;
    rollback)
      if [[ "$OSTYPE" == "darwin"* ]]; then
        sudo darwin-rebuild switch --rollback
      else
        sudo nixos-rebuild switch --rollback
      fi
      ;;
    diff)
      diff_command
      ;;
    generations)
      generations_command
      ;;
    help|--help|-h)
      show_help
      ;;
    *)
      echo "❌ Unknown command: $1"
      echo ""
      show_help
      exit 1
      ;;
  esac
''
