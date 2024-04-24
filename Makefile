SHELL := $(shell which zsh) -e

.PHONY: apply-uguisu
apply-uguisu:
	nix build ".#darwinConfigurations.uguisu.system" --extra-experimental-features "nix-command flakes"
	./result/sw/bin/darwin-rebuild switch --flake ".#uguisu"

.PHONY: apply-emu
apply-emu:
	sudo nixos-rebuild switch --flake ".#emu"

