{
  inputs,
  withSystem,
  config,
  ...
}: let
  Hosts = import ../lib/hosts.nix {inherit inputs;};
  vscodeOverlay = _final: prev: let
    masterPkgs = import inputs.nixpkgs-master {
      inherit (prev) system config;
    };
  in {
    inherit (masterPkgs) vscode vscode-with-extensions;
  };
in {
  flake.nixosConfigurations = {
    emu = let
      system = "x86_64-linux";
    in
      withSystem system ({pkgs, ...}: let
        siteLib = import ../lib {
          inherit pkgs;
          inherit (pkgs) lib;
          inherit config;
        };
      in
        Hosts.mkNixos {
          inherit system siteLib;
          hostPath = ../hosts/emu;
          users = {
            momeemt = ../home/emu;
          };
          extraModules = with inputs; [
            NixVirt.nixosModules.default
            vscode-server.nixosModules.default
            comin.nixosModules.comin
          ];
          overlays = [vscodeOverlay];
        });

    shime = let
      system = "x86_64-linux";
    in
      withSystem system ({pkgs, ...}: let
        siteLib = import ../lib {
          inherit pkgs;
          inherit (pkgs) lib;
          inherit config;
        };
      in
        Hosts.mkNixos {
          inherit system siteLib;
          hostPath = ../hosts/shime;
          users = {
            momeemt = ../home/shime;
          };
          extraModules = with inputs; [
            NixVirt.nixosModules.default
            vscode-server.nixosModules.default
            comin.nixosModules.comin
          ];
          overlays = [vscodeOverlay];
        });

    oshidori = let
      system = "x86_64-linux";
    in
      withSystem system ({pkgs, ...}: let
        siteLib = import ../lib {
          inherit pkgs;
          inherit (pkgs) lib;
          inherit config;
        };
      in
        Hosts.mkNixos {
          inherit system siteLib;
          hostPath = ../hosts/oshidori;
          users = {
            momeemt = ../home/oshidori;
          };
          extraModules = with inputs; [
            vscode-server.nixosModules.default
            comin.nixosModules.comin
          ];
          overlays = [vscodeOverlay];
        });
  };

  flake.darwinConfigurations = {
    uguisu = let
      system = "aarch64-darwin";
    in
      withSystem system ({pkgs, ...}: let
        siteLib = import ../lib {
          inherit pkgs;
          inherit (pkgs) lib;
          inherit config;
        };
      in
        Hosts.mkDarwin {
          inherit system siteLib;
          hostPath = ../hosts/uguisu;
          users = {
            momeemt = ../home/uguisu;
          };
          overlays = [inputs.brew-nix.overlays.default];
        });
  };
}
