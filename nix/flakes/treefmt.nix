_: {
  perSystem = {pkgs, ...}: {
    treefmt = {
      package = pkgs.treefmt;
      enableDefaultExcludes = true;
      flakeCheck = true;
      flakeFormatter = true;
      projectRootFile = "flake.nix";

      programs = {
        # GitHub Actions
        actionlint = {
          enable = true;
          package = pkgs.actionlint;
        };

        # Nix
        alejandra = {
          enable = true;
          package = pkgs.alejandra;
        };
        deadnix = {
          enable = true;
          package = pkgs.deadnix;
        };
        statix = {
          enable = true;
          package = pkgs.statix;
        };

        # Markdown
        mdformat = {
          enable = true;
          package = pkgs.mdformat;
        };

        # Python
        ruff-check = {
          enable = true;
          package = pkgs.ruff;
        };
        ruff-format = {
          enable = true;
          package = pkgs.ruff;
        };

        # sh/bash
        shellcheck = {
          enable = true;
          package = pkgs.shellcheck;
        };
        shfmt = {
          enable = true;
          package = pkgs.shfmt;
        };

        # Lua
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

        # Terraform
        terraform = {
          enable = true;
          package = pkgs.terraform;
        };

        # YAML
        yamlfmt = {
          enable = true;
          package = pkgs.yamlfmt;
        };
      };
    };
  };
}
