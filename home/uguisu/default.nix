{ pkgs, ... }: {
  imports = [
    ../../modules/direnv
    ../../modules/git
    ../../modules/neovim
    ../../modules/starship
    ../../modules/zsh
  ];

  home = {
    username = "momeemt";
    homeDirectory = "/Users/momeemt";
    stateVersion = "23.11";
    packages = import ../../system/packages { inherit pkgs; };
  };

  programs.home-manager.enable = true;
}
