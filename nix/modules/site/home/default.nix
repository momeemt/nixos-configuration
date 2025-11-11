{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
  cfg = config.site.home;
  h = config.home.homeDirectory;
  inherit (config.xdg) dataHome stateHome configHome;
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

  config.home = let
    basePackages = with pkgs;
      [
        neofetch
        gh
        ghq
        ripgrep
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
        python314
        myPackages.ncp
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [myPackages.quitapp];

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

    darwinCasks = with pkgs.brewCasks;
      lib.optionals pkgs.stdenv.isDarwin [
        # adobe-creative-cloud
        angry-ip-scanner
        bitwarden
        brave-browser
        canva
        chatgpt
        chatgpt-atlas
        discord
        docker-desktop
        element
        figma
        jetbrains-toolbox
        github
        (google-chrome.overrideAttrs (oldAttrs: {
          src = pkgs.fetchurl {
            url = lib.lists.head oldAttrs.src.urls;
            hash = "sha256-v1MwK8oFbBk+PcnP5tkh0WgYmzKGYr2VkxD+otKN9xg";
          };
        }))
        # (google-drive.overrideAttrs (oldAttrs: {
        #   src = pkgs.fetchurl {
        #     url = lib.lists.head oldAttrs.src.urls;
        #     hash = "sha256-S2Ms+HKnQ1ATnb/YhGpJTtvcce94eh5cqGcOIQDxx60=";
        #   };
        #   unpackPhase = "";
        # }))
        # (hhkb.overrideAttrs (oldAttrs: {
        #   unpackPhase = "";
        # }))
        httpie-desktop
        # karabiner-elements
        keybase
        keycastr
        # (logitech-g-hub.overrideAttrs (oldAttrs: {
        #   src = pkgs.fetchurl {
        #     url = lib.lists.head oldAttrs.src.urls;
        #     hash = "sha256-Nx2TXDr22KkVVOV0lNI8t/0zCqFc2fjFl9mFWxdQFOw=";
        #   };
        # }))
        # (logitech-options.overrideAttrs (oldAttrs: {
        #   src = pkgs.fetchurl {
        #     url = lib.lists.head oldAttrs.src.urls;
        #     hash = "sha256-qAEdpofRCYk2DAyqIxxSXnxx2qF6rA0Zmbk0s8+1Rqc=";
        #   };
        # }))
        loom
        microsoft-edge
        microsoft-excel
        (lib.meta.hiPrio microsoft-outlook)
        microsoft-powerpoint
        (microsoft-teams.overrideAttrs (oldAttrs: {
          nativeBuildInputs = with pkgs; (oldAttrs.nativeBuildInputs or []) ++ [pbzx];
          unpackPhase = ''
            set -euo pipefail
            xar -xf "$src" MicrosoftTeams_app.pkg/Payload
            pbzx -n MicrosoftTeams_app.pkg/Payload | cpio -idm
          '';
        }))
        microsoft-word
        notchnook
        notion
        obs
        obsidian
        ollama-app
        readdle-spark
        setapp
        slack
        (spotify.overrideAttrs (oldAttrs: {
          src = pkgs.fetchurl {
            url = lib.lists.head oldAttrs.src.urls;
            hash = "sha256-gEZxRBT7Jo2m6pirf+CreJiMeE2mhIkpe9Mv5t0RI58=";
          };
        }))
        # synology-drive
        # tailscale-app
        todoist-app
        # unity
        (unity-hub.overrideAttrs (oldAttrs: {
          src = pkgs.fetchurl {
            url = lib.lists.head oldAttrs.src.urls;
            hash = "sha256-sj1ZdeVk/p5ZQfR75HMDVYnmAPzcyYIAFaRYXQPZK2s=";
          };
        }))
        visual-studio-code
        # windows-app
        zoom
      ];

    combined =
      basePackages
      ++ (lib.optionals cfg.groups.linuxDesktop linuxDesktopPackages)
      ++ (lib.optionals cfg.groups.darwinCasks darwinCasks)
      ++ darwinCasks
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
        PYTHONSTARTUP = "${../../../../scripts/python-startup.py}";
        AZURE_CONFIG_DIR = "${configHome}/azure";
        DOCKER_CONFIG = "${configHome}/docker";
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
}
