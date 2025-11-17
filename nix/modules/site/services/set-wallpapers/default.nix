{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.site.services.set-wallpapers;
  inherit (lib) mkIf mkOption mkEnableOption types;
in {
  options.site.services.set-wallpapers = {
    enable = mkEnableOption "Enable setting wallpapers service for macOS Tahoe.";

    wallpapers = mkOption {
      type = types.listOf types.path;
      default = [];
      description = "List of wallpaper image paths (e.g. fetchurl results).";
    };
  };

  config = let
    wallpaperList = builtins.concatStringsSep ":" cfg.wallpapers;
    setWallpapers = pkgs.writeShellScript "set-wallpapers" (
      builtins.readFile ./main.sh
    );
  in
    mkIf cfg.enable {
      launchd.user.agents.set-wallpapers = {
        path = with pkgs; [coreutils];

        environment = {
          WALLPAPERS = wallpaperList;
          SET_APPLESCRIPT = "${./set.applescript}";
        };

        script = "${setWallpapers}";

        serviceConfig = {
          StartInterval = 300;
          KeepAlive = false;
          RunAtLoad = true;
          StandardOutPath = "/tmp/set-wallpapers.log";
          StandardErrorPath = "/tmp/set-wallpapers.err.log";
        };
      };
    };
}
