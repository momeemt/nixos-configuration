SHELL := $(shell which zsh) -e

.PHONY: build
build: nixpkgs-fmt # shellcheck
	home-manager switch -f home.nix
	nix run nix-darwin -- switch --flake .

.PHONY: nixpkgs-fmt
nixpkgs-fmt:
	find . -name '*.nix' -print0 | while IFS= read -r -d '' file; do \
		nixpkgs-fmt "$$file"; \
	done

.PHONY: shellcheck
shellcheck:
	find . -path './zsh/*' -print0 | while IFS= read -r -d '' file; do \
		shellcheck -x -s bash "$$file"; \
	done

