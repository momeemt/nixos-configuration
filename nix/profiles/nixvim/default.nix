{
  programs.nixvim = {
    enable = true;

    viAlias = true;
    vimAlias = true;

    colorschemes.vscode.enable = true;
    clipboard.register = "unnamedplus";
    extraConfigLua = ''
      local osc52 = require('vim.ui.clipboard.osc52')
      vim.g.clipboard = {
        name = 'OSC 52',
        copy = {
          ['+'] = osc52.copy('+'),
          ['*'] = osc52.copy('*'),
        },
        paste = {
          ['+'] = osc52.paste('+'),
          ['*'] = osc52.paste('*'),
        },
      }
    '';

    highlight = {
      Normal = {
        bg = "none";
        ctermbg = "none";
      };
      NonText = {
        bg = "none";
        ctermbg = "none";
      };
      NormalNC = {bg = "none";};
      NormalSB = {bg = "none";};
      NvimTreeNormal = {bg = "none";};
      NvimTreeNormalNC = {bg = "none";};
      NvimTreeEndOfBuffer = {bg = "none";};
      NvimTreeWinSeparator = {bg = "none";};
      NvimTreeStatusLine = {bg = "none";};
      NvimTreeStatusLineNC = {bg = "none";};
    };

    plugins = {
      wakatime.enable = true;
      web-devicons.enable = true;
    };

    imports = [
      ./keymaps.nix
      ./opts.nix
      ./plugins/barbar.nix
      ./plugins/cmp.nix
      ./plugins/copilot-lua.nix
      ./plugins/gitblame.nix
      ./plugins/hop.nix
      ./plugins/indent-blankline.nix
      ./plugins/lsp.nix
      ./plugins/lualine.nix
      ./plugins/nvim-autopairs.nix
      ./plugins/nvim-surround.nix
      ./plugins/nvim-tree.nix
    ];
  };
}
