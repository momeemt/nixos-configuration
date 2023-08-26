{
  programs.git = {
    enable = true;
    userName = "Mutsuha Asada";
    userEmail = "me@momee.mt";
    aliases = {
      st = "status";
      d = "diff";
      a = "add";
      aa = "add --all";
      cm = "commit -m";
    };
    ignores = [
      ".DS_Store"
      ".direnv"
      ".envrc"
    ];
    difftastic = {
      enable = true;
      background = "light";
    };
  };
}

