# It requires to enable CalDAV API (Google API)
{config, ...}: {
  programs.khal.enable = true;
  programs.vdirsyncer.enable = true;
  services.vdirsyncer.enable = true;

  accounts.calendar = {
    basePath = "${config.xdg.dataHome}/calendar";
    accounts = {
      "google_calendar_me_momee_mt" = {
        khal = {
          enable = true;
          type = "discover";
        };
        remote.type = "google_calendar";
        local = {
          type = "filesystem";
          path = "${config.xdg.dataHome}/calendar/google";
        };
        vdirsyncer = {
          enable = true;
          metadata = [
            "color"
            "displayname"
          ];
          collections = [
            "from a"
            "from b"
          ];
          clientIdCommand = [
            "cat"
            config.sops.secrets."google-me-momee-mt-client-id".path
          ];
          clientSecretCommand = [
            "cat"
            config.sops.secrets."google-me-momee-mt-client-secret".path
          ];
          tokenFile = "${config.xdg.cacheHome}/vdirsyncer/google/me@momee.mt/calendar_token";
        };
      };
    };
  };
}
