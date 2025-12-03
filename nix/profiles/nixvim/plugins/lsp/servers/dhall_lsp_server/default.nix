{pkgs, ...}: {
  programs.nixvim.plugins.lsp.servers.dhall_lsp_server = {
    enable = true;
    package = pkgs.dhall-lsp-server;
  };
}
