{
  services.comin = {
    enable = true;
    remotes = [
      {
        name = "origin";
        url = "https://github.com/momeemt/nixos-configuration";
        branches.main.name = "main";
      }
    ];
  };
}
