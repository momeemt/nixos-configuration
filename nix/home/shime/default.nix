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
    ../../modules/site/home
  ];

  home = {
    username = "momeemt";
    homeDirectory = "/home/momeemt";
    stateVersion = "25.05";
  };

  site.home.username = "momeemt";
  programs.home-manager.enable = true;
}
