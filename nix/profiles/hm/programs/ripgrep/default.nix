{pkgs, ...}: let
  ignoreGlob = path: "--glob=!${path}";
in {
  programs.ripgrep = {
    enable = true;
    package = pkgs.ripgrep;
    arguments = [
      "--hidden"
      "--smart-case"
      "--line-number"
      "--colors=path:fg:cyan"
      (ignoreGlob ".git/")
      (ignoreGlob "node_modules/")
      (ignoreGlob "target/")
      (ignoreGlob "dist/")
      (ignoreGlob "result/")
    ];
  };
}
