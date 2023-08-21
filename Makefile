SHELL := $(shell which zsh)

.PHONY: build
build: nixpkgs-fmt
	home-manager switch -f home.nix

.PHONY: nixpkgs-fmt
nixpkgs-fmt:
	find . -name '*.nix' -print0 | while IFS= read -r -d '' file; do \
		nixpkgs-fmt "$$file"; \
	done

