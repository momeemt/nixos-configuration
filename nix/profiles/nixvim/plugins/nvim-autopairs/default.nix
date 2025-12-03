{pkgs, ...}: {
  programs.nixvim.plugins.nvim-autopairs = {
    enable = true;
    package = pkgs.vimPlugins.nvim-autopairs;

    settings = {
      enable_abbr = false;
      enable_afterquote = true;
      enable_bracket_in_quote = true;
      enable_check_bracket_line = true;
      enable_moveright = true;
      break_undo = true;
      check_ts = true;
      disable_filetype = [
        "TelescopePrompt"
      ];
      disable_in_macro = false;
      disable_in_replace_mode = true;
      disable_in_visualblock = false;
      map_bs = true;
      map_c_h = false;
      map_c_w = false;
      map_cr = true;
    };
  };
}
