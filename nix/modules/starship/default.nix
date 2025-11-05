{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format = "$shell\n$all";

      shell = {
        disabled = false;
        format = "\\[[$indicator]($style)\\]";
        style = "bold purple";
        bash_indicator = "bash";
        zsh_indicator = "zsh";
        fish_indicator = "fish";
        unknown_indicator = "!unknown!";
      };
    };
  };
}
