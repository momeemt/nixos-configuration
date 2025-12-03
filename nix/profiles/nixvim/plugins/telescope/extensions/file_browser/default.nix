{pkgs, ...}: {
  programs.nixvim.plugins.telescope = {
    extensions.file-browser = {
      enable = true;
      package = pkgs.vimPlugins.telescope-file-browser-nvim;

      settings = {
        add_dirs = true;
        auto_depth = false;
        collapse_dirs = true;
        depth = 3;
        git_status = true;
        grouped = true;
        hidden = {
          file_browser = false;
          folder_browser = false;
        };
        hide_parent_dir = false;
        hijack_netrw = true;
        prompt_path = true;
        quiet = false;
        respect_gitignore = false;
        use_fd = true;
      };
    };

    keymaps = {
      ";fb" = {
        action = "file_browser";
        options = {
          desc = "Telescope file browser";
        };
      };
    };
  };
}
