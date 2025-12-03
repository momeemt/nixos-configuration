{
  programs.nixvim.highlight = let
    none = "none";
  in {
    Normal = {
      bg = none;
      ctermbg = none;
    };
    NormalNC = {
      bg = none;
    };
    NormalSB = {
      bg = none;
    };
  };
}
