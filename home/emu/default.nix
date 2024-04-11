{ pkgs, ... }: {
  imports = [
    ../../modules/git
    ../../modules/neovim
    ../../modules/zsh
    ../../system/packages
  ];

  home = {
    username = "momeemt";
    homeDirectory = "/home/momeemt";
    stateVersion = "23.11";
  };

  programs.home-manager.enable = true;
}
