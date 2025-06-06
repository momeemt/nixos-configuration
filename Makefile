SHELL := $(shell which zsh)
.SHELLFLAGS := -eu -o pipefail -c
HOSTNAME := $(shell uname -n)
FLAKE_ROOT := .
NIX_FLAGS := --extra-experimental-features 'nix-command flakes'

HOSTS := uguisu emu oshidori

uguisu_FLAKE_TARGET := darwinConfigurations.uguisu.system
uguisu_SWITCH_COMMAND := sudo ./result/sw/bin/darwin-rebuild switch --flake '$(FLAKE_ROOT)\#uguisu'
emu_SWITCH_COMMAND := sudo nixos-rebuild switch --flake '$(FLAKE_ROOT)\#emu'
oshidori_SWITCH_COMMAND := sudo nixos-rebuild switch --flake '$(FLAKE_ROOT)\#oshidori'

.DEFAULT_GOAL := apply
apply: $(HOSTNAME)

$(uguisu_FLAKE_TARGET):
	@nix build '$(FLAKE_ROOT)#$(uguisu_FLAKE_TARGET)' $(NIX_FLAGS)

uguisu: $(uguisu_FLAKE_TARGET)
	@$(uguisu_SWITCH_COMMAND)

emu oshidori:
	@$($(*)_SWITCH_COMMAND)

.PHONY: $(HOSTS) apply

