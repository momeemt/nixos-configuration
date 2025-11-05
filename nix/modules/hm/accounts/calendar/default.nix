# It requires to enable CalDAV API (Google API)
{config, ...}: {
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

  assertions = let
    mkMessage = collection: package: "accounts.calendar: some accounts enable ${package}, but ${collection}.${package}.enable = false.";
  in [
    {
      assertion = config.programs.khal.enable;
      message = mkMessage "programs" "khal";
    }
    {
      assertion = config.programs.vdirsyncer.enable;
      message = mkMessage "programs" "vdirsyncer";
    }
    {
      assertion = config.services.vdirsyncer.enable;
      message = mkMessage "services" "vdirsyncer";
    }
  ];
}
