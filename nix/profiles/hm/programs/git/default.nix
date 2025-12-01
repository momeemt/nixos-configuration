{
  pkgs,
  lib,
  ...
}: {
  programs.git = {
    enable = true;

    settings =
      {
        user = {
          name = "Mutsuha Asada";
          email = "me@momee.mt";
        };
        alias = {
          st = "status";
          d = "diff";
          a = "add";
          aa = "add --all";
          cm = "commit -m";
          pom = "push origin main";
          poh = "push origin head";
          pocur = "!git push origin $(git branch --contains | cut -d \" \" -f 2)";
          remget = "remote get-url origin";
          remset = "remote set-url origin";
          stp = "stash pop";
        };
        http = {
          postBuffer = 524288000;
        };
        init = {
          defaultBranch = "main";
        };
      }
      // lib.optionalAttrs pkgs.stdenv.isDarwin {
        credential = {
          helper = "osxkeychain";
        };
      };

    ignores = [
      ".DS_Store"
      ".direnv"
      ".envrc"
      ".momeemt"
    ];

    lfs = {
      enable = true;
    };
  };
}
