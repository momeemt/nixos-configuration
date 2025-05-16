{lib, ...}: {
    keymaps = let
      arrows = ["<Up>" "<Down>" "<Left>" "<Right>"];
    in [
      {
        mode = "i";
	key = "jj";
	action = "<Esc>";
	options = {
	  noremap = true;
	  silent = true;
	};
      }
    ] ++ lib.map (arrow: {
	mode = [ "i" "n" "v" ];
	key = arrow;
	action = "<Nop>";
	options = {
	  noremap = true;
	  silent = true;
        };
      }) arrows;
}
