{pkgs, ...}: {
  programs.nixvim.plugins.lsp.servers.lua_ls = {
    enable = true;
    package = pkgs.lua-language-server;
    settings = {
      diagnostics = {
        globals = [
          "vim"
        ];
      };
    };
  };
}
