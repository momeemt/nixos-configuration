{inputs, ...}: {
  perSystem = {system, ...}: {
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
  };
}
