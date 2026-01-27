{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkIf mkEnableOption mkMerge types mapAttrs' nameValuePair;
  inherit (pkgs.stdenv) isDarwin;

  cfg = config.site.services.activitywatch;
  tomlFormat = pkgs.formats.toml {};

  binPath = "${cfg.package}/Applications/ActivityWatch.app/Contents/MacOS";

  watcherModule = types.submodule ({
    name,
    config,
    ...
  }: {
    options = {
      name = mkOption {
        type = types.str;
        default = name;
        description = "The name of the watcher.";
      };

      package = mkOption {
        type = types.package;
        description = "The package providing the watcher executable.";
      };

      executable = mkOption {
        type = types.str;
        default = config.name;
        description = "The executable name if different from the watcher name.";
      };

      settings = mkOption {
        inherit (tomlFormat) type;
        default = {};
        description = "Configuration for this watcher in TOML format.";
      };

      settingsFilename = mkOption {
        type = types.str;
        default = "${config.name}.toml";
        description = "Basename for the generated settings file.";
      };

      extraOptions = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Extra arguments passed to the watcher executable.";
      };
    };
  });
in {
  options.site.services.activitywatch = {
    enable = mkEnableOption "ActivityWatch time tracker (Darwin)";

    package = mkOption {
      type = types.package;
      description = "The ActivityWatch package to use.";
    };

    settings = mkOption {
      inherit (tomlFormat) type;
      default = {};
      description = "Configuration for aw-server-rust in TOML format.";
    };

    extraOptions = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Additional command-line arguments passed to the server.";
    };

    watchers = mkOption {
      type = types.attrsOf watcherModule;
      default = {};
      description = "ActivityWatch watcher definitions.";
    };
  };

  config = mkIf (cfg.enable && isDarwin) (mkMerge [
    {
      launchd.agents.activitywatch-server = {
        enable = true;
        config = {
          ProgramArguments =
            ["${binPath}/aw-server"]
            ++ cfg.extraOptions;
          KeepAlive = true;
          RunAtLoad = true;
          StandardOutPath = "${config.home.homeDirectory}/Library/Logs/activitywatch-server.log";
          StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/activitywatch-server.err.log";
        };
      };

      xdg.configFile = let
        serverSettings =
          if cfg.settings != {}
          then {
            "activitywatch/aw-server-rust/config.toml".source =
              tomlFormat.generate "aw-server-rust-config" cfg.settings;
          }
          else {};

        watcherSettings = lib.foldl' (acc: wcfg:
          acc
          // (
            if wcfg.settings != {}
            then {
              "activitywatch/${wcfg.name}/${wcfg.settingsFilename}".source =
                tomlFormat.generate "aw-watcher-${wcfg.name}-config" wcfg.settings;
            }
            else {}
          )) {}
        (builtins.attrValues cfg.watchers);
      in
        serverSettings // watcherSettings;
    }
    {
      launchd.agents =
        mapAttrs' (
          name: wcfg:
            nameValuePair "activitywatch-watcher-${name}" {
              enable = true;
              config = {
                ProgramArguments =
                  ["${binPath}/${wcfg.executable}"]
                  ++ wcfg.extraOptions;
                KeepAlive = true;
                RunAtLoad = true;
                StandardOutPath = "${config.home.homeDirectory}/Library/Logs/activitywatch-watcher-${name}.log";
                StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/activitywatch-watcher-${name}.err.log";
              };
            }
        )
        cfg.watchers;
    }
  ]);
}
