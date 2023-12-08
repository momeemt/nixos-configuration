SHELL := $(shell which zsh) -e

.PHONY: build
build: build-darwin build-home

.PHONY: build-darwin
build-darwin: nixpkgs-fmt shellcheck
	nix run nix-darwin -- switch --flake .

.PHONY: build-home
build-home: nixpkgs-fmt shellcheck
	home-manager switch -f home.nix

.PHONY: rebuild-emu
rebuild-emu:
	sudo nixos-rebuild switch -I nixos-config=./hosts/emu/configuration.nix

.PHONY: nixpkgs-fmt
nixpkgs-fmt:
	find . -name '*.nix' -print0 | while IFS= read -r -d '' file; do \
		nixpkgs-fmt "$$file"; \
	done

.PHONY: shellcheck
shellcheck:
	find . -path './zsh/*' -type f -print0 | while IFS= read -r -d '' file; do \
		shellcheck -x -s bash "$$file"; \
	done

