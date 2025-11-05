{
  plugins.cmp = {
    enable = true;
    autoEnableSources = true;
    settings = {
      sources = [
        {name = "nvim_lsp";}
        {name = "path";}
        {name = "buffer";}
      ];
      mapping = {
        "<C-b>" = "cmp.mapping.scroll_docs(-4)";
        "<C-f>" = "cmp.mapping.scroll_docs(4)";
        "<C-j>" = "cmp.mapping.select_next_item()";
        "<C-k>" = "cmp.mapping.select_prev_item()";
        "<C-Space>" = "cmp.mapping.complete()";
        "<C-c>" = "cmp.mapping.close()";
        "<CR>" = ''
          cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          })
        '';
      };
    };
  };
}
