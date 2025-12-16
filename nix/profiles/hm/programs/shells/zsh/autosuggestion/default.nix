{lib, ...}: let
  generate-highlight = {
    fg ? null,
    bg ? null,
    bold ? false,
    underline ? false,
    standout ? false,
  }:
    if fg == null && bg == null && !bold && !underline && !standout
    then "none"
    else
      lib.concatStringsSep "," (lib.filter (s: s != "")
        [
          (lib.optionalString (fg != null) "fg=${fg}")
          (lib.optionalString (bg != null) "bg=${bg}")
          (lib.optionalString bold "bold")
          (lib.optionalString underline "underline")
          (lib.optionalString standout "standout")
        ]);
in {
  programs.zsh.autosuggestion = {
    enable = true;
    highlight = generate-highlight {
      fg = "#90A4AE";
      bold = true;
    };
    strategy = [
      "history"
      "completion"
    ];
  };
}
