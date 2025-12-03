{pkgs, ...}: {
  programs.nixvim.plugins.lsp.servers.denols = {
    enable = true;
    package = pkgs.deno;

    filetypes = [
      "deno.json"
      "deno.jsonc"
    ];

    settings = {
      enable = true;
      suggest = {
        imports = {
          hosts = {
            "https://deno.land" = true;
          };
        };
      };
    };
  };
}
