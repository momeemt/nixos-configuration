{
  inputs = {
    nixpkgs = {
      owner = "NixOS";
      repo = "nixpkgs";
      rev = "959d8a84bff0f9bff8525b9b074085269ddf5d79";
      type = "github";
    };
    flake-utils = {
      owner = "numtide";
      repo = "flake-utils";
      rev = "919d646de7be200f3bf08cb76ae1f09402b6f9b4";
      type = "github";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs { inherit system; };
      inherit (home-manager.lib) homeManagerConfiguration;
    in
    {
      homeConfigurations.momeemt = homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
        ];
      };

      packages.aarch64-darwin.darwinConfigurations.uguisu = nix-darwin.lib.darwinSystem {
        modules = [
          ./darwin/configuration.nix
        ];
        inherit system;
      };

      devShell.aarch64-darwin = pkgs.mkShell {
        buildInputs = with pkgs; [
          shellcheck
          nixpkgs-fmt
        ];
      };
    };
}
