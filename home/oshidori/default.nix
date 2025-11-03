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
        google-chrome
        spotify
        teams-for-linux
        discord
        vesktop
        wl-clipboard
        todoist-electron
        todoist
        gnome-screenshot
        mpv
        usbutils
        (import ../../packages/ncp {inherit pkgs;})
      ]
      ++ import ../../system/packages {inherit pkgs;};
  };

  programs.home-manager.enable = true;
}
