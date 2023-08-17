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
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "cp"
        "direnv"
        "docker"
        "git"
        "github"
        "golang"
        "keychain"
        "node"
        "npm"
        "rsync"
        "ssh-agent"
        "sudo"
        "terraform"
        "tmux"
      ];
      theme = "robbyrussell";
    };
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
