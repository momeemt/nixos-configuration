{
  programs.nixvim.keymaps = [
    {
      mode = "i";
      key = "jj";
      action = "<Esc>";
      options = {
        noremap = true;
        silent = true;
      };
    }
  ];
}
