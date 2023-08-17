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
      nim-vim
      vim-commentary
      {
        plugin = vim-indent-guides;
        config = ''
          let g:indent_guides_enable_on_vim_startup = 1
        '';
      }
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
