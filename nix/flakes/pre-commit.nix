_: {
  perSystem = {
    config,
    lib,
    ...
  }: {
    pre-commit = {
      check.enable = true;
      settings = {
        hooks = {
          treefmt = {
            enable = true;
            packageOverrides = {
              treefmt = lib.getExe config.treefmt.build.wrapper;
            };
          };
        };
      };
    };
  };
}
