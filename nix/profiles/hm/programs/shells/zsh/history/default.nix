{config, ...}: {
  programs.zsh.history = {
    append = true;
    expireDuplicatesFirst = true;
    extended = true;
    findNoDups = true;
    ignoreAllDups = true;
    ignoreDups = true;
    ignorePatterns = [
      # cledentials
      "*TOKEN*=* *"
      "*KEY*=* *"
      "*SECRET*=* *"
      "*PASSWORD*=* *"
      "*Authorization:*"
      "*authorization:*"
      "*--token *"
      "*--api-key *"
      "*--password *"

      # frequent
      "ls"
      "ls *"
      "cd"
      "cd *"
      "pwd"
      "clear"
      "exit"
      "just apply*"
      "direnv allow"
      "treefmt*"
      "xdg-compliance-checker*"
      "git st*"
      "git status*"
      "git aa*"
      "git d"
      "git d *"
      "git diff*"
      "zshrc"
      "bashrc"
    ];
    ignoreSpace = false;
    path = "${config.xdg.stateHome}/zsh/history";
    save = 10000;
    saveNoDups = true;
    share = true;
    size = 10000;
  };
}
