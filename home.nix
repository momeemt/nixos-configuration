{ config, pkgs, ... }:
let inherit (builtins) getEnv;
in {
  home = {
    username = "momeemt";
    homeDirectory = "/Users/momeemt";
    stateVersion = "22.11";
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

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
    };
  };

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      {
        plugin = kanagawa-nvim;
        config = ''
          colorscheme kanagawa
        '';
      }
    ];
  };
}
