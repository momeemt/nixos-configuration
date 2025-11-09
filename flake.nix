{
  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({...}: {
      imports = with inputs; [
        treefmt-nix.flakeModule
        git-hooks-nix.flakeModule
        ./nix/flakes/per-system.nix
        ./nix/flakes/hosts.nix
      ];

      systems = import inputs.systems;
    });

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.05";
    sops-nix.url = "github:Mic92/sops-nix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    git-hooks-nix.url = "github:cachix/git-hooks.nix";
    nixvim.url = "github:nix-community/nixvim/nixos-25.05";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    tmux-nix.url = "github:momeemt/tmux-nix";
    brew-nix.url = "github:BatteredBunny/brew-nix";
    brew-api.url = "github:BatteredBunny/brew-api";
    NixVirt.url = "https://flakehub.com/f/AshleyYakeley/NixVirt/v0.6.0.tar.gz";
    comin.url = "github:nlewo/comin";
    mac-app-util.url = "github:hraban/mac-app-util";

    # --- inputs.<input>.follows ---
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    git-hooks-nix.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    tmux-nix.inputs.nixpkgs.follows = "nixpkgs";
    brew-nix.inputs.brew-api.follows = "brew-api";
    brew-nix.inputs.nixpkgs.follows = "nixpkgs";
    brew-nix.inputs.nix-darwin.follows = "nix-darwin";
    brew-api.flake = false;
    NixVirt.inputs.nixpkgs.follows = "nixpkgs";
    comin.inputs.nixpkgs.follows = "nixpkgs";
    # see https://github.com/hraban/mac-app-util/issues/39#issuecomment-3503946041
    mac-app-util.inputs.cl-nix-lite.url = "github:r4v3n6101/cl-nix-lite/url-fix";
  };
}
