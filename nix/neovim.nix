{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    withPython3 = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = builtins.readFile ../neovim/init.vim;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      nim-vim
      vim-commentary
      luasnip
      nvim-treesitter-parsers.yaml
      copilot-vim
      {
        plugin = telescope-nvim;
        type = "lua";
        config = builtins.readFile ../neovim/plugins/telescope-nvim.lua;
      }
      telescope-live-grep-args-nvim
      telescope-frecency-nvim
      lualine-nvim
      phpactor
      deoplete-nvim
      {
        plugin = lualine-nvim;
        type = "lua";
        config = builtins.readFile ../neovim/plugins/lualine.lua;
      }
      {
        plugin = oceanic-material;
        config = builtins.readFile ../neovim/plugins/oceanic-material.vim;
      }
      {
        plugin = vim-indent-guides;
        config = builtins.readFile ../neovim/plugins/vim-indent-guides.vim;
      }
      {
        plugin = fern-vim;
        config = builtins.readFile ../neovim/plugins/fern.vim;
      }
      vim-vsnip
      {
        plugin = nvim-cmp;
        type = "lua";
        config = builtins.readFile ../neovim/plugins/nvim-cmp.lua;
      }
      cmp-nvim-lsp
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = builtins.readFile ../neovim/plugins/nvim-lspconfig.lua;
      }
      lexima-vim
      {
        plugin = barbar-nvim;
        type = "lua";
        config = builtins.readFile ../neovim/plugins/barbar-nvim.lua;
      }
      nvim-web-devicons
      {
        plugin = nvim-surround;
        type = "lua";
        config = builtins.readFile ../neovim/plugins/nvim-surround.lua;
      }
    ];
  };
}

