# https://github.com/nim-lang/nimble/blob/839a3779aa94422beb79f714c579bbe9170594e9/nimble-guide/docs/config.md
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.site.programs.nimble;
  inherit (lib) mkOption mkEnableOption types;
in {
  options.site.programs.nimble = {
    enable = mkEnableOption "Enable Nimble (install and configure nimble.ini).";

    package = mkOption {
      type = types.package;
      default = pkgs.nimble;
      description = "The Nimble package to install.";
    };

    nimbleDir = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Directory used by Nimble for package installation.
        Default is "~/.nimble/" if not specified.
      '';
    };

    cloneUsingHttps = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to replace any "git://" URLs with "https://".
      '';
    };

    httpProxy = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Proxy URL used for downloading package lists.
      '';
    };

    # packageLists = mkOption {
    #   type = types.listOf (types.submodule (_: {
    #     options = {
    #       name = mkOption {
    #         type = types.str;
    #         description = "Name of the package list section.";
    #       };
    #       url = mkOption {
    #         type = types.nullOr (types.either types.str (types.listOf types.str));
    #         default = null;
    #         description = "A URL or a list of URLs to packages.json";
    #       };
    #       path = mkOption {
    #         type = types.nullOr types.str;
    #         default = null;
    #         description = "Local path to a packages.json file.";
    #       };
    #     };
    #   }));
    #   default = [];
    #   description = "List of custom [PackageList] sections.";
    # };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];

    # assertions = [{
    #   assertion = lib.all (pl: (pl.url != null) != (pl.path != null)) cfg.packageLists;
    #   message = "site.programs.nimble.packageLists: specify only either `url` or `path` for each field.";
    # }];

    xdg.configFile."nimble/nimble.ini".text = lib.generators.toINIWithGlobalSection {} {
      globalSection = (lib.optionalAttrs (cfg.nimbleDir != null) {
        nimbleDir = cfg.nimbleDir;
      })
      // {
        cloneUsingHttps = cfg.cloneUsingHttps;
      }
      // (lib.optionalAttrs (cfg.httpProxy != null) {
        httpProxy = cfg.httpProxy;
      });
    };
  };
}
