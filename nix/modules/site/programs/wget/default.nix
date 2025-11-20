{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.site.programs.wget;
  inherit (lib) mkOption mkEnableOption mkIf types;
in {
  options.site.programs.wget = {
    enable = mkEnableOption "Enable wget and configure it with XDG-aware defaults.";

    package = mkOption {
      type = types.package;
      default = pkgs.wget;
      description = "The wget package to install.";
    };

    wgetrc = {
      path = mkOption {
        type = types.str;
        default = "${config.xdg.configHome}/wget/wgetrc";
        description = "Absolute path to the main wget configuration file (WGETRC). Usually under XDG_CONFIG_HOME.";
      };
      extra = mkOption {
        type = types.lines;
        default = "";
        description = "Extra configuration lines appended at the end of the generated wgetrc.";
      };
    };

    hstsFile = {
      path = mkOption {
        type = types.str;
        default = "${config.xdg.cacheHome}/wget/wget-hsts";
        description = "Absolute path to the wget HSTS database file. wget requires this to be an absolute path.";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = [cfg.package];

      sessionVariables = {
        WGETRC = cfg.wgetrc.path;
      };

      file."${cfg.wgetrc.path}".text = ''
        hsts-file = ${cfg.hstsFile.path}
        ${cfg.wgetrc.extra}
      '';
    };
  };
}
