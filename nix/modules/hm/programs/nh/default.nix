{
  pkgs,
  config,
  siteLib,
  ...
}: {
  programs.nh = {
    enable = true;
    package = pkgs.nh;

    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep 5 --keep-since 3d";
    };

    flake = "${config.xdg.dataHome}/ghq/${siteLib.githubRepository.url}";
  };
}
