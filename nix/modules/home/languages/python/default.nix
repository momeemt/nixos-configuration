{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkOption mkIf types;
  inherit (config.xdg) stateHome configHome cacheHome dataHome;
  cfg = config.site.languages.python;
in {
  options.site.languages.python = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Python development environment";
    };
    package = mkOption {
      type = types.package;
      default = pkgs.python315;
      description = "The Python package to install.";
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = [
        (lib.meta.hiPrio cfg.package)
      ];
      sessionVariables = {
        PYTHONSTARTUP = "${configHome}/python/pythonstartup";
        PYTHONHISTFILE = "${stateHome}/python/history";
        PYTHONUSERBASE = "${dataHome}/python";
        PIP_CONFIG_FILE = "${configHome}/pip/pip.conf";
        PIP_CACHE_DIR = "${cacheHome}/pip";
        # https://matplotlib.org/stable/api/matplotlib_configuration_api.html#matplotlib.get_configdir
        MPLCONFIGDIR = "${configHome}/matplotlib";
      };
    };
    xdg.configFile = {
      "python/pythonstartup".source = ./python-startup.py;
    };
  };
}
