{
  pkgs,
  lib,
  config,
  ...
}: {
  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.sway;

    config = {
      terminal = "${pkgs.alacritty}/bin/alacritty";
      menu = "${pkgs.fuzzel}.bin/fuzzel";
      modifier = "Mod4";

      keybindings = let
        swayConfig = config.wayland.windowManager.sway.config;
        mod = swayConfig.modifier;
      in
        lib.mkOptionDefault {
          "${mod}+Return" = "exec ${swayConfig.terminal}";
          "${mod}+d" = "exec ${swayConfig.menu}";
          "${mod}+Shift+e" = "exec swaymsg exit";
        };
    };
  };
}
