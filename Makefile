SHELL := $(shell which zsh) -e

.PHONY: apply
apply:
	@HOSTNAME=$$(uname -n); \
	if [[ "$$HOSTNAME" == "uguisu" ]]; then \
		nix build ".#darwinConfigurations.uguisu.system" --extra-experimental-features "nix-command flakes"; \
		sudo ./result/sw/bin/darwin-rebuild switch --flake ".#uguisu"; \
	elif [[ "$$HOSTNAME" == "emu" ]]; then \
		sudo nixos-rebuild switch --flake ".#emu"; \
	elif [[ "$$HOSTNAME" == "oshidori" ]]; then \
		sudo nixos-rebuild switch --flake ".#oshidori"; \
	else \
		echo "Unsupported host: $$HOSTNAME" >&2; \
		exit 1; \
	fi

