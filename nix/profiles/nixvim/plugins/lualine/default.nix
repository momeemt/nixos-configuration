{pkgs, ...}: {
  programs.nixvim.plugins.lualine = {
    enable = true;
    package = pkgs.vimPlugins.lualine-nvim;
  };
}
