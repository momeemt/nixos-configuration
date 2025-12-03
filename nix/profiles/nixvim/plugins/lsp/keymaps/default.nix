{config, ...}: let
  helpers = config.lib.nixvim;
in {
  programs.nixvim.plugins.lsp.keymaps = {
    diagnostic = {
      "<space>e" = "open_float";
      "[d" = "goto_prev";
      "]d" = "goto_next";
      "<space>q" = "setloclist";
    };
    lspBuf = {
      "gD" = "declaration";
      "gd" = "definition";
      "K" = "hover";
      "gi" = "implementation";
      "<C-k>" = "signature_help";
      "<space>wa" = "add_workspace_folder";
      "<space>wr" = "remove_workspace_folder";
      "<space>D" = "type_definition";
      "<space>rn" = "rename";
      "<space>ca" = "code_action";
      "gr" = "references";
    };
    extra = [
      {
        key = "<space>wl";
        action = helpers.mkRaw ''
          function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end
        '';
      }
      {
        key = "<space>f";
        action = helpers.mkRaw ''
          function()
            vim.lsp.buf.format({ async = true })
          end
        '';
      }
    ];
  };
}
