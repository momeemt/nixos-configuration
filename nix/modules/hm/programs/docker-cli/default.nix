{config, ...}: {
  programs.docker-cli = {
    enable = true;
    configDir = "${config.xdg.configHome}/docker";
  };
}