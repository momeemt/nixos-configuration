{
  pkgs,
  inputsFrom,
  easy-purescript-nix,
  system,
}: let
  inherit (pkgs) lib stdenv;
  easy-ps = easy-purescript-nix.packages.${system};
in
  pkgs.mkShell {
    inherit inputsFrom;

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
      ++ lib.optionals stdenv.isDarwin [
        apple-sdk
      ];
  }
