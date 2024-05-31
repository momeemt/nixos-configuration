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
    homeDirectory = "/home/momeemt";
    stateVersion = "23.11";
    packages = with pkgs; [
      age
      sops
      cloudflared
      quartus-prime-lite
    ] ++ import ../../system/packages { inherit pkgs; };
  };

  programs.home-manager.enable = true;
}
