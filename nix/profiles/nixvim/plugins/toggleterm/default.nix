{pkgs, ...}: {
  programs.nixvim.plugins.toggleterm = {
    enable = true;
    package = pkgs.vimPlugins.toggleterm-nvim;

    settings = {
      direction = "float";
      float_opts = {
        border = "curved";
        height = 30;
        width = 130;
      };
      open_mapping = "[[<c-t>]]";
    };
  };
}
