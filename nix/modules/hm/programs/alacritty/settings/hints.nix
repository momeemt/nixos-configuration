{pkgs, ...}: {
  programs.alacritty.settings.hints = {
    alphabet = "jfkdls;ahgurieowpq"; # default
    enabled = [
      {
        regex = "(https?://[^\\\\s]+)";
        post_processing = true;
        hyperlinks = true;
        command =
          if pkgs.stdenv.isDarwin
          then "open"
          else "xdg-open";
        binding = {
          key = "O";
          mods = "Control|Shift";
        };
      }
      # FIXME: the following hints do not work! 泣
      {
        regex = "(\\\\.?[^\\\\s]+)";
        post_processing = true;
        command = "${pkgs.neovim}/bin/nvim";
        binding = {
          key = "E";
          mods = "Control|Shift";
        };
      }
      {
        regex = "#[0-9]+";
        post_processing = true;
        command = {
          program = "${pkgs.gh}/bin/gh";
          args = [
            "issue"
            "view"
            "--web"
          ];
        };
        binding = {
          key = "G";
          mods = "Control|Shift";
        };
      }
    ];
  };
}
