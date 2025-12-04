{pkgs, ...}: {
  programs.nixvim.plugins.nvim-surround = {
    enable = true;
    package = pkgs.vimPlugins.nvim-surround;
  };
}
