{ pkgs, ... }: {
  imports = [
    ../../modules/alacritty
    ../../modules/direnv
    ../../modules/git
    ../../modules/neovim
    ../../modules/starship
    ../../modules/zsh
  ];

  home = {
    username = "momeemt";
    homeDirectory = "/home/momeemt";
    stateVersion = "24.11";
    packages = with pkgs; [
    ] ++ import ../../system/packages { inherit pkgs; };
  };

  programs.home-manager.enable = true;
}
