{
  pkgs,
  siteLib,
  ...
}: let
  inherit (siteLib) stateVersion;
  nixpkgsFlake = ''builtins.getFlake "github:NixOS/nixpkgs/nixos-${stateVersion}"'';
  _pkgs = "import (${nixpkgsFlake}) { }";
in {
  programs.nixvim.plugins.lsp.servers.nixd = {
    enable = true;
    package = pkgs.nixd;
    autostart = true;
    packageFallback = false;
    settings = {
      formatting = {
        command = ["${pkgs.alejandra}/bin/alejandra"];
      };

      nixpkgs.expr = _pkgs;
      options = {
        home-manager.expr = ''
          let
            hmFlake = builtins.getFlake "github:nix-community/home-manager/release-${stateVersion}";
            nixvimFlake = builtins.getFlake "github:nix-community/nixvim/nixos-${stateVersion}";
            pkgs = ${_pkgs};
          in
            (hmFlake.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [
                nixvimFlake.homeModules.nixvim
                {
                  home = {
                    username = "momeemt";
                    homeDirectory = "/home/momeemt";
                    stateVersion = "${stateVersion}";
                  };
                }
              ];
            }).options
        '';
      };
    };
  };
}
