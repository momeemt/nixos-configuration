{ pkgs, ... }:
let
  satysfi-vim-src = pkgs.fetchFromGitHub {
    owner = "qnighy";
    repo = "satysfi.vim";
    rev = "c11dc636ce2987bf122cbd6d488f40d98909a2df";
    sha256 = "sha256-Hy1RHfukwVSkT1rDrnLm5ufCqcBKFReu+FYfDM57GFM=";
  };
  satysfi-vim = pkgs.vimUtils.buildVimPlugin {
    name = "satysfi-vim";
    src = satysfi-vim-src;
  };
in
{
  programs.neovim = {
    enable = true;
    withPython3 = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = builtins.readFile ./init.vim;
    coc = {
      enable = true;
      settings = {
        languageserver = {
          satysfi-ls = {
            command = "satysfi-language-server";
            args = [ ];
            filetypes = [ "satysfi" ];
          };
        };
      };
    };
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
        config = builtins.readFile ./plugins/telescope-nvim.lua;
      }
      telescope-live-grep-args-nvim
      telescope-frecency-nvim
      lualine-nvim
      phpactor
      deoplete-nvim
      {
        plugin = lualine-nvim;
        type = "lua";
        config = builtins.readFile ./plugins/lualine.lua;
      }
      {
        plugin = oceanic-material;
        config = builtins.readFile ./plugins/oceanic-material.vim;
      }
      {
        plugin = vim-indent-guides;
        config = builtins.readFile ./plugins/vim-indent-guides.vim;
      }
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = builtins.readFile ./plugins/nvim-tree-lua.lua;
      }
      vim-vsnip
      {
        plugin = nvim-cmp;
        type = "lua";
        config = builtins.readFile ./plugins/nvim-cmp.lua;
      }
      cmp-nvim-lsp
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = builtins.readFile ./plugins/nvim-lspconfig.lua;
      }
      lexima-vim
      {
        plugin = barbar-nvim;
        type = "lua";
        config = builtins.readFile ./plugins/barbar-nvim.lua;
      }
      nvim-web-devicons
      {
        plugin = nvim-surround;
        type = "lua";
        config = builtins.readFile ./plugins/nvim-surround.lua;
      }
      satysfi-vim
      vim-wakatime
    ];
  };
}

