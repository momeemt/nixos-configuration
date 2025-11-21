{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
  cfg = config.site.home;
  h = config.home.homeDirectory;
  inherit (config.xdg) dataHome stateHome configHome cacheHome;
  pkgs-master = import inputs.nixpkgs-master {inherit system;};
in {
  options.site.home = {
    username = mkOption {
      type = types.str;
      description = "The user's username";
    };

    extraSessionPath = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of paths to be added to `home.sessionPath`";
    };

    extraSessionVariables = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = "Environment variables that are merged into `home.sessionVariables`";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Arbitrary extra packages to append to `home.packages`.";
    };

    extraDarwinCasks = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Extra GUI apps on Darwin. Ignored on Linux.";
    };

    groups = {
      linuxDesktop = mkEnableOption "Install common Linux desktop applications";
      darwinCasks = mkEnableOption "Install Homebrew casks and other macOS-specific GUI applications";
    };
  };

  config = {
    home = let
      basePackages = with pkgs;
        [
          neofetch
          gh
          ghq
          eza
          bat
          bottom
          nixpkgs-review
          gnupg
          gnumake
          yazi
          jq
          yq
          sops
          age
          cloudflared
          todoist
          usbutils
          nim
          (lib.meta.hiPrio python314)
          myPackages.ncp
          docker-client
          cloc
          nodejs_24
          pkgs-master.codex
          pkgs-master.jupyter-all
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin [
          myPackages.quitapp
          myPackages.ok
          myPackages.ng
          myPackages.subscribe
          myPackages.xdg-compliance-checker
        ];

      linuxDesktopPackages = with pkgs; [
        google-chrome
        spotify
        teams-for-linux # lab
        discord
        vesktop
        wl-clipboard
        gnome-screenshot
        todoist-electron
        mpv
      ];

      darwinCasks = import ./casks.nix {inherit pkgs lib;};

      combined =
        basePackages
        ++ (lib.optionals cfg.groups.linuxDesktop linuxDesktopPackages)
        ++ (lib.optionals cfg.groups.darwinCasks darwinCasks)
        ++ cfg.extraPackages
        ++ cfg.extraDarwinCasks;

      final = lib.unique combined;
    in {
      enableNixpkgsReleaseCheck = true;
      homeDirectory =
        if pkgs.stdenv.isLinux
        then "/home/${cfg.username}"
        else "/Users/${cfg.username}";
      inherit (cfg) username;
      preferXdgDirectories = true;

      sessionVariables =
        {
          EDITOR = "nvim";
          VISUAL = "nvim";
          LANG = "ja_JP.UTF-8";
          PAGER = "less";
          MANPAGER = "less";
          LESS = "-R";
          XDG_CONFIG_HOME = "${h}/.config";
          XDG_CACHE_HOME = "${h}/.cache";
          XDG_DATA_HOME = "${h}/.local/share";
          XDG_STATE_HOME = "${h}/.local/state";
          SATYROGRAPHOS_EXPERIMENTAL = "1";
          PYTHONHISTFILE = "${stateHome}/python/history";
          PYTHONSTARTUP = "${configHome}/python/pythonstartup";
          AZURE_CONFIG_DIR = "${configHome}/azure";
          NODE_REPL_HISTORY = "${dataHome}/node_repl_history";
          NPM_CONFIG_USERCONFIG = "${configHome}/npm/npmrc";
          GHQ_ROOT = "${dataHome}/ghq";
          WASMER_DIR = "${dataHome}/wasmer";
          OPAMROOT = "${dataHome}/opam";
          IPYTHONDIR = "${configHome}/jupyter";
          JUPYTER_CONFIG_DIR = "${configHome}/jupyter";
          JULIA_DEPOT_PATH = "${dataHome}/julia:$JULIA_DEPOT_PATH";
          ELM_HOME = "${configHome}/elm";
          CODEX_HOME = "${configHome}/codex";
          NUGET_PACKAGES = "${cacheHome}/NuGetPackages";
          GEM_HOME = "${dataHome}/gem";
          GEM_SPEC_CACHE = "${cacheHome}/gem";
          GRADLE_USER_HOME = "${dataHome}/gradle";
          EM_CONFIG = "${configHome}/emscripten/config";
          EM_CACHE = "${cacheHome}/emscripten/cache";
          EM_PORTS = "${dataHome}/emscripten/cache";
          BUNDLE_USER_CONFIG = "${configHome}/bundle";
          BUNDLE_USER_CACHE = "${cacheHome}/bundle";
          BUNDLE_USER_PLUGIN = "${dataHome}/bundle";
          CONDARC = "${configHome}/conda/condarc";
          MC_CONFIG_DIR = "${configHome}/mc";
          # https://matplotlib.org/stable/api/matplotlib_configuration_api.html#matplotlib.get_configdir
          MPLCONFIGDIR = "${configHome}/matplotlib";
          # https://doc.rust-lang.org/cargo/reference/environment-variables.html
          CARGO_HOME = "${dataHome}/cargo";
          RUSTUP_HOME = "${dataHome}/rustup";
        }
        // cfg.extraSessionVariables;

      sessionPath =
        [
          "${h}/.local/bin"
          "${dataHome}/cargo/bin"
          "${configHome}/nimble/bin"
          "${h}/go/bin"
        ]
        ++ cfg.extraSessionPath;

      packages = final;
      shell.enableShellIntegration = true;
      stateVersion = "25.05";
    };

    xdg.configFile = {
      "npm/npmrc".source = ./npmrc;
      "python/pythonstartup".source = ./python-startup.py;
    };
  };
}
