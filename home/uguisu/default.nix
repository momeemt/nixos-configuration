{ pkgs, ... }: {
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
    homeDirectory = "/Users/momeemt";
    stateVersion = "23.11";
    packages = with pkgs; [
      ghq
    ] ++ import ../../system/packages { inherit pkgs; };
  };

  programs.home-manager.enable = true;
}
