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
    ../../modules/hm/nix
    ../../modules/hm/programs/bash
    ../../modules/site/home
  ];

  site.home.username = "momeemt";
  programs.home-manager.enable = true;
}
