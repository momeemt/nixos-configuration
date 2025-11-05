{inputs}: let
  hmUsers = import ./hm-users.nix {inherit inputs;};
in {
  mkNixos = {
    system,
    hostPath,
    users,
    siteLib,
    extraModules ? [],
    overlays ? [],
  }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs siteLib;};
      modules =
        [
          hostPath
          ({...}: {nixpkgs.overlays = overlays;})
          inputs.home-manager.nixosModules.home-manager
          (hmUsers {inherit users;})
          inputs.sops-nix.nixosModules.sops
        ]
        ++ extraModules;
    };

  mkDarwin = {
    system,
    hostPath,
    users,
    siteLib,
    extraModules ? [],
    overlays ? [],
  }:
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {inherit inputs siteLib;};
      modules =
        [
          hostPath
          ({...}: {nixpkgs.overlays = overlays;})
          inputs.home-manager.darwinModules.home-manager
          (hmUsers {inherit users;})
          inputs.sops-nix.darwinModules.sops
        ]
        ++ extraModules;
    };
}
