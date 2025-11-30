{config, ...}: {
  services.dropbox = {
    enable = true;
    path = "${config.home.homeDirectory}/Documents/Dropbox";
  };
}
