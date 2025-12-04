{pkgs, ...}: let
  colors = [
    {
      name = "Red";
      hex = "#E06C75";
    }
    {
      name = "Yellow";
      hex = "#E5C07B";
    }
    {
      name = "Blue";
      hex = "#61AFEF";
    }
    {
      name = "Orange";
      hex = "#D19A66";
    }
    {
      name = "Green";
      hex = "#98C379";
    }
    {
      name = "Violet";
      hex = "#C678DD";
    }
    {
      name = "Cyan";
      hex = "#56B6C2";
    }
  ];
  rainbow = "Rainbow";
  rainbowNames = builtins.map (c: rainbow + c.name) colors;
  rainbowColors = builtins.listToAttrs (builtins.map (c: {
      name = rainbow + c.name;
      value = c.hex;
    })
    colors);
in {
  programs.nixvim.plugins.indent-blankline = {
    enable = true;
    package = pkgs.vimPlugins.indent-blankline-nvim;
    settings.indent = {
      highlight = rainbowNames;
      char = "▏";
    };
    luaConfig.pre = ''
      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        ${builtins.concatStringsSep "\n" (builtins.map (name: ''
          vim.api.nvim_set_hl(0, "${name}", { fg = "${rainbowColors.${name}}" })
        '')
        rainbowNames)}
      end)
    '';
  };
}
