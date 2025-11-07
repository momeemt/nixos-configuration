{
  inputs,
  ...
}: {
  imports = [
    ../../modules/alacritty
    ../../modules/direnv
    ../../modules/git
    inputs.nixvim.homeManagerModules.nixvim
    ../../modules/nixvim
    ../../modules/starship
    inputs.tmux-nix.homeModules.tmux-nix
    ../../modules/tmux-nix
    ../../modules/vscode
    ../../modules/zsh
    ../../modules/hm/programs/bash
    ../../modules/site/env
    ../../modules/site/packages
  ];

  home = {
    username = "momeemt";
    homeDirectory = "/home/momeemt";
    stateVersion = "25.05";
  };

  site.packages = {
    enable = true;
    groups.linuxDesktop = true;
  };

  programs.home-manager.enable = true;
}
