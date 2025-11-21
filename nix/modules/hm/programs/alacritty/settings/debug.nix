{lib, ...}: let
  debug = false;
in {
  programs.alacritty.settings.debug =
    {
      log_level = "Warn";
      print_events = false;
    }
    // lib.optionalAttrs debug {
      render_timer = true;
      persistent_logging = true;
      log_level = "Debug";
      print_events = true;
      highlight_damage = true;
    };
}
