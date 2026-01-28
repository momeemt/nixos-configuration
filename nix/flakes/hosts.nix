{
  inputs,
  withSystem,
  ...
}: let
  Hosts = import ./lib/hosts.nix {inherit inputs;};
  vscodeOverlay = _final: prev: {
    inherit (prev) vscode vscode-with-extensions;
  };
in {
  flake = {
    nixosConfigurations = {
      emu = let
        system = "x86_64-linux";
      in
        withSystem system ({pkgs, ...}: let
          siteLib = import ../lib {
            inherit pkgs system;
            inherit (pkgs) lib;
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
            inherit pkgs system;
            inherit (pkgs) lib;
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
    };

    ciConfigurations = {
      emu = inputs.self.nixosConfigurations.emu.extendModules {
        modules = [{k8sVMs.enable = inputs.nixpkgs.lib.mkForce false;}];
      };
      shime = inputs.self.nixosConfigurations.shime.extendModules {
        modules = [{k8sWorkers.enable = inputs.nixpkgs.lib.mkForce false;}];
      };
    };

    darwinConfigurations = {
      uguisu = let
        system = "aarch64-darwin";
      in
        withSystem system ({pkgs, ...}: let
          siteLib = import ../lib {
            inherit pkgs system;
            inherit (pkgs) lib;
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

    homeConfigurations = {
      example = let
        system = "x86_64-linux";
      in
        withSystem system ({pkgs, ...}: let
          siteLib = import ../lib {
            inherit pkgs system;
            inherit (pkgs) lib;
          };
        in
          inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules =
              [
                (_: {nixpkgs.overlays = [inputs.llm-agents.overlays.default] ++ import ../overlays;})
                ../home/example
              ]
              ++ (import ./lib/shared-modules.nix {inherit inputs;});
            extraSpecialArgs = {inherit inputs siteLib system;};
          });
    };
  };
}
