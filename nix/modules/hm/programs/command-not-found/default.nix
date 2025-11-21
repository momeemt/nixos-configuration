{config, ...}: {
  programs.command-not-found = {
    enable = true;
    dbPath = "${config.xdg.dataHome}/command-not-found/programs.sqlite";
  };
}
