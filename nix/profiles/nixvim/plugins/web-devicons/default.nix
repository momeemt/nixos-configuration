{pkgs, ...}: {
  programs.nixvim.plugins.web-devicons = {
    enable = true;
    package = pkgs.vimPlugins.nvim-web-devicons;
    settings = {
      strict = true;
    };
  };
}
