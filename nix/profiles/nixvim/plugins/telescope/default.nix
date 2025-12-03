{pkgs, ...}: {
  imports = [
    ./extensions
  ];

  programs.nixvim.plugins.telescope = {
    enable = true;
    package = pkgs.vimPlugins.telescope-nvim;

    keymaps = {
      ";ff" = {
        action = "find_files";
        options = {
          desc = "Telescope find files";
        };
      };
      ";g" = {
        action = "live_grep";
        options = {
          desc = "Telescope live grep";
        };
      };
      ";b" = {
        action = "buffers";
        options = {
          desc = "Telescope buffers";
        };
      };
      ";h" = {
        action = "help_tags";
        options = {
          desc = "Telescope help tags";
        };
      };
    };
  };
}
