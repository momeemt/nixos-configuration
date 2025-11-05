{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    _module.args.overlays = [
      (final: prev: let
        masterPkgs = import inputs.nixpkgs-master {
          inherit (prev) system config;
        };
      in {
        inherit (masterPkgs) vscode vscode-with-extensions;
      })
    ];
  };
}
