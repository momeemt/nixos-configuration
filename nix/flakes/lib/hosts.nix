{inputs}: let
  hmUsers = import ./hm-users.nix {inherit inputs;};
  localOverlays = with inputs;
    [
      firefox-addons.overlays.default
      llm-agents.overlays.default
      nix-openclaw.overlays.default
    ]
    ++ (import ../../overlays);
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
      specialArgs = {inherit inputs siteLib system;};
      modules =
        [
          hostPath
          (_: {nixpkgs.overlays = overlays ++ localOverlays;})
          inputs.home-manager.nixosModules.home-manager
          (hmUsers {inherit users siteLib system;})
          inputs.sops-nix.nixosModules.sops
          ../../modules/host
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
      specialArgs = {
        inherit inputs siteLib system;
      };
      modules =
        [
          hostPath
          (_: {nixpkgs.overlays = overlays ++ localOverlays;})
          inputs.home-manager.darwinModules.home-manager
          (hmUsers {
            inherit users siteLib system;
            extraSharedModules = with inputs; [
              mac-app-util.homeManagerModules.default
            ];
          })
          inputs.sops-nix.darwinModules.sops
          inputs.mac-app-util.darwinModules.default
          ../../modules/host
        ]
        ++ extraModules;
    };
}
