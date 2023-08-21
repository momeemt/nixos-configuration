{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = builtins.readFile ../neovim/init.vim;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      nim-vim
      vim-commentary
      nvim-cmp
      luasnip
      nvim-treesitter-parsers.yaml
      copilot-vim
      telescope-nvim
      lualine-nvim
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
    ];
  };
}

