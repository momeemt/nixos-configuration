{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkIf types;
  cfg = config.site.programs.karabiner-elements;
  inherit (pkgs.stdenv) isDarwin;
in {
  options.site.programs.karabiner-elements = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Karabiner-Elements (Darwin only) and manager its configuration.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.karabiner-elements;
      description = "Karabiner-Elements package to install (Darwin only).";
    };

    settings = mkOption {
      type = types.attrs;
      default = {};
      description = ''
        Karabiner-Elements configuration as a Nix attrset.
        Will be written to karabiner.json via builtins.toJSON.
      '';
    };
  };

  config = mkIf (cfg.enable && isDarwin) {
    home.packages = [cfg.package];
    xdg.configFile."karabiner/karabiner.json".text = builtins.toJSON cfg.settings;
  };
}
