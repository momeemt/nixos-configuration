{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
  h = config.home.homeDirectory;
  cfg = config.site.env;
in {
  options.site.env = {
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
  };

  config = {
    home.sessionVariables =
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
      }
      // cfg.extraSessionVariables;

    home.sessionPath =
      [
        "${h}/.local/bin"
        "${h}/.cargo/bin"
        "${h}/.nimble/bin"
        "${h}/go/bin"
      ]
      ++ cfg.extraSessionPath;
  };
}
