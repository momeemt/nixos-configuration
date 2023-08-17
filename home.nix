{ config, pkgs, ... }:
let inherit (builtins) getEnv;
in {
  home = {
    username = "momeemt";
    homeDirectory = "/Users/momeemt";
    stateVersion = "23.05";
  };

  nix = {
    package = pkgs.nixFlakes;
    settings = {
      experimental-features = "nix-command flakes";
    };
  };
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      set number relativenumber
    '';
    plugins = with pkgs.vimPlugins; [
      vim-nix
    ];
  };

  programs.tmux = {
    enable = true;
  };
}
