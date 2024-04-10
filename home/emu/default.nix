{ pkgs, ... }: {
  imports = [
    ../../modules/git
    ../../modules/neovim
    ../../modules/zsh
  ];

  home = {
    username = "momeemt";
    homeDirectory = "/home/momeemt";
    stateVersion = "23.11";
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    gh
    neofetch
  ];
}
