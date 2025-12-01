{pkgs, ...}: {
  programs.difftastic = {
    enable = true;
    package = pkgs.difftastic;
    options = {
      background = "light";
    };
  };
}
