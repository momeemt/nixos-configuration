{
  pkgs,
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
    ../../modules/site/env
  ];

  home = {
    username = "momeemt";
    homeDirectory = "/home/momeemt";
    stateVersion = "25.05";
    packages = with pkgs;
      [
        age
        sops
        cloudflared
        quartus-prime-lite
      ]
      ++ import ../../system/packages {inherit pkgs;};
  };

  programs.home-manager.enable = true;
}
