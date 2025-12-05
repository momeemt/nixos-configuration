_: {
  perSystem = {pkgs, ...}: {
    treefmt = {
      package = pkgs.treefmt;
      enableDefaultExcludes = true;
      flakeCheck = true;
      flakeFormatter = true;
      projectRootFile = "flake.nix";

      programs = {
        actionlint.enable = true;
        alejandra.enable = true;
        deadnix.enable = true;
        just.enable = true;
        mdformat.enable = true;
        ruff-check.enable = true;
        ruff-format.enable = true;
        shellcheck.enable = true;
        shfmt.enable = true;
        statix.enable = true;
        stylua.enable = true;
        terraform.enable = true;
        yamlfmt.enable = true;
      };
    };
  };
}
