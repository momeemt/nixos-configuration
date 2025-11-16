import 'just-flake.just'

host_name := `uname -n`
flake_root := "."
nix_flags := "--extra-experimental-features 'nix-command flakes'"

showtrace_env := env_var_or_default("SHOWTRACE", "false")
showtrace_flag := if showtrace_env == "true" { "--show-trace" } else { "" }

dev_env := env_var_or_default("DEV", "false")
dev_flag := if dev_env == "true" { "--override-input tmux-nix path:./nix/flakes/tmux-nix" } else { "" }

[doc("List all available just commands")]
default:
	just --list

[doc("Build and apply the configuration for the current host")]
apply:
	#!/usr/bin/env zsh
	set -euo pipefail
	@case {{host_name}} in
		uguisu)
			@nix build \
				{{showtrace_flag}} \
				'{{flake_root}}#darwinConfigurations.{{host_name}}.system' \
				{{nix_flags}} \
				{{dev_flag}}
			sudo ./result/sw/bin/darwin-rebuild switch \
				--flake '{{flake_root}}#{{host_name}}'
			;;
		emu | oshidori | shime)
			sudo nixos-rebuild switch \
				{{showtrace_flag}} --flake '{{flake_root}}#{{host_name}}' \
				{{nix_flags}} \
				{{dev_flag}}
			;;
		*)
			@echo "Unknown host: {{host_name}}"
			exit 1
			;;
	esac
