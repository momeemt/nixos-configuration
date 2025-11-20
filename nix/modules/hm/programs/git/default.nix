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
      poh = "push origin head";
      pocur = "!git push origin $(git branch --contains | cut -d \" \" -f 2)";
      remget = "remote get-url origin";
      remset = "remote set-url origin";
      stp = "stash pop";
    };
    ignores = [
      ".DS_Store"
      ".direnv"
      ".envrc"
      ".momeemt"
    ];
    difftastic = {
      enable = true;
      background = "light";
    };
  };
}
