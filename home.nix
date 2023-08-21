{ config, pkgs, ... }:
let inherit (builtins) getEnv;
in {
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

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        size = 12.0;
      };
      scrolling = {
        history = 10000;
      };
      window = {
        opacity = 0.7;
        padding = {
          x = 8;
          y = 4;
        };
      };
      shell = {
        program = "${pkgs.zsh}/bin/zsh";
        args = [
          "-l"
          "-c"
          "${pkgs.tmux}/bin/tmux attach || ${pkgs.tmux}/bin/tmux new-session"
        ];
      };
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = builtins.readFile ./neovim/init.vim;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      nim-vim
      vim-commentary
      nvim-cmp
      luasnip
      nvim-treesitter-parsers.yaml
      copilot-vim
      telescope-nvim
      lualine-nvim
      {
        plugin = lualine-nvim;
        type = "lua";
        config = builtins.readFile ./neovim/plugins/lualine.lua;
      }
      {
        plugin = oceanic-material;
        config = builtins.readFile ./neovim/plugins/oceanic-material.vim;
      }
      {
        plugin = vim-indent-guides;
        config = builtins.readFile ./neovim/plugins/vim-indent-guides.vim;
      }
      {
        plugin = fern-vim;
        config = builtins.readFile ./neovim/plugins/fern.vim;
      }
    ];
  };

  programs.tmux = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Mutsuha Asada";
    userEmail = "me@momee.mt";
  };

  programs.exa = {
    enable = true;
  };

  programs.bat = {
    enable = true;
  };
}
