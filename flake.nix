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

  outputs = { self, nixpkgs, home-manager, nix-darwin, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        inherit (builtins) getEnv;
        inherit (home-manager.lib) homeManagerConfiguration;
        pkgs = import nixpkgs { inherit system; };
      in
      {
        homeConfigurations = {
          momeemt = homeManagerConfiguration {
            inherit pkgs;
            modules = [ ./home.nix ];
          };
        };

        darwinConfigurations = {
          momeemt = nix-darwin.lib.darwinSystem {
            modules = [ ./darwin/configuration.nix ];
          };
        };

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            shellcheck
            nixpkgs-fmt
          ];
        };
      }
    );
}
