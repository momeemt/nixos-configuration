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
      pom = "push origin main";
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
    signing = {
      key = "ACB54F0CBC6AA7C6";
      signByDefault = true;
    };
  };
}

