{
  programs.alacritty.settings.window = {
    # use tmux
    dimensions = {
      columns = 0;
      lines = 0;
    };
    position = "None";
    # padding = {
    #   x = 8;
    #   y = 8;
    # };
    dynamic_padding = true;
    decorations = "None";
    opacity = 0.8;
    # blur = true;
    # use AeroSpace
    startup_mode = "Windowed";
    dynamic_title = true;
    decorations_theme_variant = "None";
    resize_increments = false;
    option_as_alt = "OnlyLeft";
    # use AeroSpace
    level = "Normal";
  };
}
