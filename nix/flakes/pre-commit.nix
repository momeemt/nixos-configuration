_: {
  perSystem = {
    config,
    pkgs,
    pkgs-master,
    lib,
    ...
  }: {
    pre-commit = {
      check.enable = true;
      inherit pkgs;
      settings = {
        enable = true;
        package = pkgs.pre-commit;
        addGcRoot = true;
        default_stages = ["pre-commit"];
        gitPackage = pkgs.gitMinimal;
        hooks = {
          action-validator = {
            enable = true;
            package = pkgs.action-validator;
          };
          flake-checker = {
            enable = true;
            package = pkgs-master.flake-checker;
          };
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
