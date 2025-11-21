{
  pkgs,
  lib,
  ...
} @ args: let
  systemConfig = args.systemConfig or null;
in {
  programs.alacritty.settings.font = let
    family = "JetBrainsMono Nerd Font Mono";
  in {
    normal = {
      inherit family;
      style = "Regular";
    };
    bold = {
      inherit family;
      style = "Bold";
    };
    italic = {
      inherit family;
      style = "Italic";
    };
    bold_italic = {
      inherit family;
      style = "Bold Italic";
    };
    builtin_box_drawing = false;
    offset = {
      x = 0;
      y = 12;
    };
    glyph_offset = {
      x = 0;
      y = 6;
    };
    size = 12;
  };

  assertions =
    lib.optional (systemConfig != null)
    {
      assertion = builtins.elem pkgs.nerd-fonts.jetbrains-mono systemConfig.fonts.packages;
      message = ''
        JetBrainsMono Nert Font is not included in `fonts.packages` on the host system.
        The Alacritty configuration requires this font to be installed on the host side.
      '';
    };
}
