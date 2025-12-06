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
        mdformat.enable = true;
        ruff-check.enable = true;
        ruff-format.enable = true;
        shellcheck.enable = true;
        shfmt.enable = true;
        statix.enable = true;

        stylua = {
          enable = true;
          package = pkgs.stylua;
          settings = {
            call_parentheses = "Always";
            collapse_simple_statement = "Never";
            column_width = 120;
            indent_type = "Spaces";
            indent_width = 2;
            line_endings = "Unix";
            quote_style = "AutoPreferDouble";
            sort_requires.enabled = true;
          };
        };

        terraform.enable = true;
        yamlfmt.enable = true;
      };
    };
  };
}
