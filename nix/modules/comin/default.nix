{siteLib, ...}: {
  services.comin = {
    enable = true;
    remotes = [
      {
        name = "origin";
        url = "https://${siteLib.githubRepository.url}";
        branches.main.name = siteLib.githubRepository.defaultBranch;
      }
    ];
  };
}
