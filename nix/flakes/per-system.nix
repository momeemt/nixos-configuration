{inputs, ...}: {
  perSystem = {
    system,
    config,
    lib,
    ...
  }: {
    _module.args = {
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = import ../overlays;
      };
      pkgs-master = import inputs.nixpkgs-master {
        inherit system;
        config.allowUnfree = true;
      };
    };

    just-flake.features = {
      treefmt.enable = true;
    };

    pre-commit = {
      check.enable = true;
      settings = {
        src = ./.;
        hooks = {
          treefmt = {
            enable = true;
            entry = lib.getExe config.treefmt.build.wrapper;
          };
        };
      };
    };
  };
}
