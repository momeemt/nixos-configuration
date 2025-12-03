{
  imports = [
    ./keymaps
    ./servers
  ];

  programs.nixvim.plugins.lsp = {
    enable = true;
  };
}
