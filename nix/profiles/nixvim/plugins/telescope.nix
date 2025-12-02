{pkgs, ...}: {
  plugins.telescope = {
    enable = true;
    package = pkgs.vimPlugins.telescope-nvim;
  };
}
