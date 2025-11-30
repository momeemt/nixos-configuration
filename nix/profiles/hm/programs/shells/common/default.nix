{
  imports = [
    ./aliases.nix
  ];

  home.shell = {
    enableBashIntegration = true;
    enableShellIntegration = true;
    enableZshIntegration = true;
  };
}
