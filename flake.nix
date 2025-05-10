{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
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
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {flake-parts, ...} @ inputs:
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
            nil
            lua-language-server
            nodePackages.vim-language-server
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
        # system security lab.
        oshidori = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = with inputs; [
            ./hosts/oshidori
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.momeemt = import ./home/oshidori;
            }
          ];
        };
      };

      flake.darwinConfigurations = {
        uguisu = inputs.nixpkgs-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = with inputs; [
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
