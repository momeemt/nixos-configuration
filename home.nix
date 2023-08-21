{ config, pkgs, ... }:
let inherit (builtins) getEnv;
in {
  imports = [
    ./nix/alacritty.nix
    ./nix/git.nix
    ./nix/neovim.nix
    ./nix/starship.nix
    ./nix/tmux.nix
    ./nix/zsh.nix
  ];

  home = {
    username = "momeemt";
    homeDirectory = "/Users/momeemt";
    stateVersion = "23.05";
    packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
        ];
      })
    ];
  };

  nix = {
    package = pkgs.nixFlakes;
    settings = {
      experimental-features = "nix-command flakes";
    };
  };

  programs.home-manager.enable = true;
  programs.exa.enable = true;
  programs.bat.enable = true;
}

