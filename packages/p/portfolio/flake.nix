{
  description = "momee.mt";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    easy-purescript-nix.url = "github:justinwoo/easy-purescript-nix";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    easy-purescript-nix,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
        frameworks = pkgs.darwin.apple_sdk.frameworks;
        easy-ps = easy-purescript-nix.packages.${system};
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs;
            [
              nil
              alejandra
              easy-ps.purs-0_15_15
              easy-ps.spago
              easy-ps.purescript-language-server
              easy-ps.purs-tidy
              dhall
              dhall-lsp-server
              nodejs_22
              esbuild
              tailwindcss
            ]
            ++ lib.optional stdenv.isDarwin [
              frameworks.Security
              frameworks.CoreFoundation
              frameworks.CoreServices
            ];
        };
      }
    );
}
