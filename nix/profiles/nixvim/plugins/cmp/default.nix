{pkgs, ...}: {
  programs.nixvim.plugins.cmp = {
    enable = true;
    package = pkgs.vimPlugins.nvim-cmp;
    autoEnableSources = true;
    settings = {
      sources = [
        {name = "nvim_lsp";}
        {name = "path";}
        {name = "buffer";}
      ];
    };
  };
}
