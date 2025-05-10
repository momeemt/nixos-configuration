{pkgs, ...}: {
  imports = [
    ../../modules/alacritty
    ../../modules/direnv
    ../../modules/git
    ../../modules/neovim
    ../../modules/starship
    ../../modules/tmux
    ../../modules/zsh
  ];

  home = {
    username = "momeemt";
    homeDirectory = "/home/momeemt";
    stateVersion = "24.11";
    packages = with pkgs;
      [
        google-chrome
        spotify
        teams-for-linux
        discord
        wl-clipboard
        todoist-electron
        todoist
        gnome-screenshot
      ]
      ++ import ../../system/packages {inherit pkgs;};
  };

  programs.home-manager.enable = true;
}
