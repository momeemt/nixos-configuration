{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.site.packages;
  ncp = import ../../../packages/ncp {inherit pkgs;};
in {
  options.site.packages = {
    enable = mkEnableOption "opinionated home.packages combiner";

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

  config = mkIf cfg.enable (let
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
    home.packages = final;
  });
}
