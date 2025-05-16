{
  programs.nixvim = {
    enable = true;
    colorschemes.gruvbox.enable = true;
    opts = {
      number = true;
      relativenumber = true;
      autoindent = true;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      incsearch = true;
      showmode = true;
      hls = true;
    };

    plugins = {
      web-devicons = {
        enable = true;
      };
    };

    imports = [
      ./keymaps.nix
      ./plugins/lsp.nix
      ./plugins/nvim-autopairs.nix
      ./plugins/nvim-surround.nix
      ./plugins/nvim-tree.nix
    ];
  };
}
