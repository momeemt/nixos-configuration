{pkgs, ...}: {
  programs.gh = {
    enable = true;
    package = pkgs.gh;

    extensions = with pkgs; [
      gh-s # search github repositories interactively
      gh-i # search github issues interactively
      gh-f # GitHub CLI ultimate FZF extension
      gh-poi # To safely clean up your local branches
      gh-cal # GitHub contributions calender terminal viewer
      gh-dash # To display a dashboard with pull requests and issues
      gh-notify # To display GitHub notifications
      gh-markdown-preview # To preview Markdown looking like on GitHub
    ];

    gitCredentialHelper = {
      enable = true;
      hosts = [
        "https://github.com"
        "https://gist.github.com"
      ];
    };

    hosts = {
      "github.com" = {
        user = "momeemt";
        git_protocol = "https";
        users = [
          "momeemt"
        ];
      };
    };

    settings = {
      git_protocol = "https";
      editor = "nvim";
      aliases = {
        co = "pr checkout";
      };
    };
  };
}
