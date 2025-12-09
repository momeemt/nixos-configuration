{pkgs, ...}: {
  programs.gemini-cli = {
    enable = true;
    package = pkgs.gemini-cli;
  };
}
