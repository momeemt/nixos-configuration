{pkgs, ...}: {
  programs.nixvim = {
    plugins.hop = {
      enable = true;
      package = pkgs.vimPlugins.hop-nvim;
    };

    keymaps = let
      mode = ["n" "x" "o"];
      options = {
        silent = true;
        noremap = true;
      };
    in [
      {
        key = "s";
        action = "<cmd>HopWord<CR>";
        inherit mode options;
      }
      {
        key = "S";
        action = "<cmd>HopChar2<CR>";
        inherit mode options;
      }
    ];
  };
}
