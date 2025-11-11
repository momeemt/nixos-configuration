{config, ...}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "emacs";
    dotDir = ".config/zsh";

    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      path = "${config.xdg.stateHome}/zsh/history";
      save = 10000;
      share = true;
      size = 10000;
    };

    shellAliases = {
      ls = "eza";
      ll = "eza -la";
      l = "eza -l";
      la = "eza -a";
      lt = "eza --tree";
      bash = "/run/current-system/sw/bin/bash";
      zsh = "/run/current-system/sw/bin/zsh";

      # Git shortcuts
      gs = "git status";
      gd = "git diff";
      gdc = "git diff --cached";
      gl = "git log --oneline --graph --decorate";
      gco = "git checkout";
      gcb = "git checkout -b";
      gp = "git push";
      gpl = "git pull";

      # Nix shortcuts
      nrs = "make apply";
      nfu = "nix flake update";
      nfc = "nix flake check";
      nfmt = "nix fmt";
      ndev = "nix develop";

      # Quick navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
    };

    completionInit = ''
      typeset -U fpath
      fpath=(${./completions} ${./functions} $fpath)
      autoload -U compinit
      compinit -i
    '';

    initContent = ''
      typeset -U path
      bindkey -r "^[[A"
      bindkey -r "^[[B"
      bindkey -r "^[[C"
      bindkey -r "^[[D"

      autoload -Uz nr

      unset __HM_SESS_VARS_SOURCED
      source ${config.xdg.stateHome}/nix/profiles/home-manager/home-path/etc/profile.d/hm-session-vars.sh

      # Useful functions for development

      # Quick rebuild and switch
      rebuild() {
        echo "🔄 Rebuilding NixOS configuration..."
        make apply
      }

      # Search for files with fzf
      ff() {
        if command -v fzf &> /dev/null && command -v fd &> /dev/null; then
          fd --type f --hidden --exclude .git | fzf --preview 'bat --color=always --style=numbers --line-range :500 {}'
        else
          find . -type f | grep -v ".git"
        fi
      }

      # Search in files with ripgrep and fzf
      rg-fzf() {
        if command -v fzf &> /dev/null && command -v rg &> /dev/null; then
          rg --color=always --line-number --no-heading --smart-case "''${*:-}" |
            fzf --ansi \
                --color "hl:-1:underline,hl+:-1:underline:reverse" \
                --delimiter : \
                --preview 'bat --color=always {1} --highlight-line {2}' \
                --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
        else
          rg "''${*:-}"
        fi
      }

      # cd to git root
      cdg() {
        local git_root
        git_root=$(git rev-parse --show-toplevel 2>/dev/null)
        if [ -n "$git_root" ]; then
          cd "$git_root" || return 1
        else
          echo "Not in a git repository"
          return 1
        fi
      }

      # Quick nix build with nom (nix output monitor)
      nom-build() {
        if command -v nom &> /dev/null; then
          nom build "''${@}"
        else
          nix build "''${@}"
        fi
      }
    '';
  };
}
