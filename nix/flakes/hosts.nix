{
  inputs,
  withSystem,
  ...
}: let
  Hosts = import ../../lib/hosts.nix {inherit inputs;};
in {
  flake.nixosConfigurations = {
    emu = let
      system = "x86_64-linux";
    in
      withSystem system ({pkgs, ...}: let
        siteLib = import ../../lib {
          inherit pkgs;
          inherit (pkgs) lib;
        };
      in
        Hosts.mkNixos {
          inherit system siteLib;
          hostPath = ../../hosts/emu;
          users = {
            momeemt = ../../home/emu;
          };
          extraModules = with inputs; [
            NixVirt.nixosModules.default
            vscode-server.nixosModules.default
            comin.nixosModules.comin
          ];
        });

    shime = let
      system = "x86_64-linux";
    in
      withSystem system ({pkgs, ...}: let
        siteLib = import ../../lib {
          inherit pkgs;
          inherit (pkgs) lib;
        };
      in
        Hosts.mkNixos {
          inherit system siteLib;
          hostPath = ../../hosts/shime;
          users = {
            momeemt = ../../home/shime;
          };
          extraModules = with inputs; [
            NixVirt.nixosModules.default
            vscode-server.nixosModules.default
            comin.nixosModules.comin
          ];
        });

    oshidori = let
      system = "x86_64-linux";
    in
      withSystem system ({pkgs, ...}: let
        siteLib = import ../../lib {
          inherit pkgs;
          inherit (pkgs) lib;
        };
      in
        Hosts.mkNixos {
          inherit system siteLib;
          hostPath = ../../hosts/oshidori;
          users = {
            momeemt = ../../home/oshidori;
          };
          extraModules = with inputs; [
            vscode-server.nixosModules.default
            comin.nixosModules.comin
          ];
        });
  };

  flake.darwinConfigurations = {
    uguisu = let
      system = "aarch64-darwin";
    in
      withSystem system ({pkgs, ...}: let
        siteLib = import ../../lib {
          inherit pkgs;
          inherit (pkgs) lib;
        };
      in
        Hosts.mkDarwin {
          inherit system siteLib;
          hostPath = ../../hosts/uguisu;
          users = {
            momeemt = ../../home/uguisu;
          };
          extraModules = with inputs; [
            ({...}: {
              nixpkgs.overlays = [
                brew-nix.overlays.default
              ];
            })
          ];
        });
  };
}
