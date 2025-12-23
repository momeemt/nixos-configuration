{pkgs, ...}: {
  programs.difftastic = {
    enable = true;
    package = pkgs.difftastic;
    git = {
      enable = true;
      diffToolMode = true;
    };
    options = {
      background = "light";
    };
  };
}
