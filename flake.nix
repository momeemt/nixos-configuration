{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils = {
      owner = "numtide";
      repo = "flake-utils";
      rev = "919d646de7be200f3bf08cb76ae1f09402b6f9b4";
      type = "github";
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
