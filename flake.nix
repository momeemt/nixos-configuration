{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      inherit (builtins) getEnv;
      inherit (home-manager.lib) homeManagerConfiguration;
    in {
      homeConfigurations = {
        momeemt = let
          system = "aarch64-darwin";
          pkgs = import nixpkgs { inherit system; };
        in homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
        };
    };
  };
}
