{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    tmux-nix = {
      url = "github:momeemt/tmux-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    brew-nix = {
      url = "github:BatteredBunny/brew-nix";
      inputs = {
        brew-api.follows = "brew-api";
        nixpkgs.follows = "nixpkgs";
        nix-darwin.follows = "nix-darwin";
      };
    };
    brew-api = {
      url = "github:BatteredBunny/brew-api";
      flake = false;
    };
  };

  outputs = {flake-parts, ...} @ inputs: let
    vscodeOverlay = _final: prev: let
      masterPkgs = import inputs.nixpkgs-master {
        inherit (prev) system;
        inherit (prev) config;
      };
    in {
      inherit (masterPkgs) vscode;
      inherit (masterPkgs) vscode-with-extensions;
    };
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = with inputs; [
        treefmt-nix.flakeModule
        git-hooks-nix.flakeModule
      ];

      systems = import inputs.systems;

      perSystem = {
        pkgs,
        config,
        ...
      }: {
        devShells.default = pkgs.mkShell {
          inputsFrom = [
            config.treefmt.build.devShell
          ];
          buildInputs = with pkgs; [
            mdbook
          ];
        };

        treefmt = {
          projectRootFile = "flake.nix";
          programs = {
            actionlint.enable = true;
            alejandra.enable = true;
            deadnix.enable = true;
            mdformat.enable = true;
            shellcheck.enable = true;
            shfmt = {
              enable = true;
              includes = [
                "*.sh"
                "*.bash"
                "*.envrc"
                "*.envrc.*"
                "*.zsh"
                "**/zshrc"
                "**/zprofile"
              ];
            };
            statix.enable = true;
            stylua.enable = true;
            yamlfmt.enable = true;
          };
          settings.global.excludes = [
            "LICENSE-*"
            "secrets/secrets.yml"
            ".github/CODEOWNERS"
            ".gitattributes"
            "modules/tmux/tmux.conf"
            "*.vim"
            "Makefile"
          ];
        };
      };

      flake.nixosConfigurations = {
        emu = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = with inputs; [
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

        shime = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = with inputs; [
            ./hosts/shime
            (_: {
              nixpkgs.overlays = [vscodeOverlay];
            })
            home-manager.nixosModules.home-manager
            vscode-server.nixosModules.default
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {inherit inputs;};
              home-manager.users.momeemt = import ./home/shime;
              home-manager.backupFileExtension = "hm-bak";
            }
          ];
        };

        # system security lab.
        oshidori = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = with inputs; [
            ./hosts/oshidori
            (_: {
              nixpkgs.overlays = [vscodeOverlay];
            })
            home-manager.nixosModules.home-manager
            vscode-server.nixosModules.default
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {inherit inputs;};
              home-manager.users.momeemt = import ./home/oshidori;
            }
          ];
        };
      };

      flake.darwinConfigurations = {
        uguisu = inputs.nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = with inputs; [
            ./hosts/uguisu
            (_: {
              nixpkgs.overlays = [inputs.brew-nix.overlays.default];
            })
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {inherit inputs;};
              home-manager.users.momeemt = import ./home/uguisu;
            }
          ];
        };
      };
    };
}
