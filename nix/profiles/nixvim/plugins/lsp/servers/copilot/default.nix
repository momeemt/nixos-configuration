{pkgs, ...}: {
  programs.nixvim.plugins.lsp.servers.copilot = {
    enable = true;
    package = pkgs.copilot-language-server;
    packageFallback = false;
    autostart = true;
  };
}
