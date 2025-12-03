{lib, ...}: {
  programs.nixvim.keymaps = let
    arrows = [
      "<Up>"
      "<Down>"
      "<Left>"
      "<Right>"
    ];
  in
    lib.map (arrow: {
      mode = ["i" "n" "v"];
      key = arrow;
      action = "<Nop>";
      options = {
        noremap = true;
        silent = true;
      };
    })
    arrows;
}
