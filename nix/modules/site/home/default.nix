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
  ncp = import ../../../packages/ncp {inherit pkgs;};
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
    basePackages = with pkgs; [
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
      ncp
      nim
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

    darwinCasks =
      lib.optionals pkgs.stdenv.isDarwin [
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
        # https://doc.rust-lang.org/cargo/reference/environment-variables.html
        CARGO_HOME = "${dataHome}/cargo";
        RUSTUP_HOME = "${dataHome}/rustup";
      }
      // cfg.extraSessionVariables;

    sessionPath =
      [
        "${h}/.local/bin"
        "${dataHome}/cargo/bin"
        "${configHome}/.nimble/bin"
        "${h}/go/bin"
      ]
      ++ cfg.extraSessionPath;

    packages = final;
    shell.enableShellIntegration = true;
    stateVersion = "25.05";
  };
}
