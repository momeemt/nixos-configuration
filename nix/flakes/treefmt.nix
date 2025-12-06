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
          no-lambda-arg = false;
          no-lambda-pattern-names = false;
          no-underscore = false;
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

        # Dockerfile
        dockerfmt = {
          enable = true;
          package = pkgs.dockerfmt;
        };

        # Text
        autocorrect = {
          enable = true;
          package = pkgs.autocorrect;
          threads = 0; # auto
          settings = {
            context = {
              codeblock = "error";
            };
            rules = {
              fullwidth = "off";
              halfwidth-punctuation = "error";
              halfwidth-word = "error";
              no-space-fullwidth = "error";
              space-backticks = "error";
              space-bracket = "error";
              space-dash = "error";
              space-dollar = "error";
              space-punctuation = "error";
              space-word = "error";
              spellcheck = "warning";
            };
            # spellcheck.words = [];
            # textRules = {};
          };
        };
      };
    };
  };
}
