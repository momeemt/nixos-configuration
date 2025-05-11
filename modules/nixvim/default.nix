{
  programs.nixvim = {
    enable = true;
    colorschemes.gruvbox.enable = true;
    plugins = {
      nvim-tree = {
        enable = true;
      };
    };
  };
}
