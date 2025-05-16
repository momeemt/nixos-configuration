{
  plugins = {
    nvim-tree = {
      enable = true;
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<C-n>";
      action = "<cmd>NvimTreeToggle<CR>";
      options = {
        silent = true;
        noremap = true;
      };
    }
  ];
}
