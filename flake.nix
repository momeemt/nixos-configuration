{
  nixConfig = {
    experimental-features = ["nix-command" "flakes"];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
    flake-utils.url = "github:numtide/flake-utils";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = {
    nixpkgs,
    home-manager,
    darwin,
    sops-nix,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            nil
            alejandra
            lua-language-server
            nodePackages.vim-language-server
          ];
        };
      }
    )
    // {
      nixosConfigurations = {
        emu = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/emu
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.momeemt = import ./home/emu;
            }
            sops-nix.nixosModules.sops
          ];
        };
      };

      darwinConfigurations = {
        uguisu = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./hosts/uguisu
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.momeemt = import ./home/uguisu;
            }
          ];
        };
      };
    };
}
