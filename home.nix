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
      set autoindent
      set tabstop=2
      set shiftwidth=2
      set expandtab
      set hls
    '';
    plugins = with pkgs.vimPlugins; [
      vim-nix
      {
        plugin = fern-vim;
        config = ''
          let g:fern#default_hidden=1
          nnoremap <C-n> :Fern . -reveal=% -drawer -toggle -width=40<CR>
        '';
      }
    ];
  };

  programs.tmux = {
    enable = true;
  };
}
