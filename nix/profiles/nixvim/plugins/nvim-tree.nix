{
  plugins = {
    nvim-tree = {
      enable = true;
      openOnSetup = true;
      settings = {
        git = {
          ignore = false;
        };
        on_attach = {
          __raw = ''
            function(bufnr)
              local api = require("nvim-tree.api")
              api.config.mappings.default_on_attach(bufnr)
              vim.keymap.set("n", "l", api.node.open.edit, {
                desc = "nvim-tree: Edit or Open",
                buffer = bufnr,
                noremap = true,
                silent = true,
                nowait = true,
              })
            end
          '';
        };
        filters = {
          custom = [
            "^\\.git$"
            "^node_modules"
            "^.direnv"
          ];
        };
      };
    };
  };

  keymaps = let
    options = {
      silent = true;
      noremap = true;
    };
  in [
    {
      mode = "n";
      key = "<C-n>";
      action = "<cmd>NvimTreeToggle<CR>";
      inherit options;
    }
  ];
}
