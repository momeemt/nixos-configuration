# It requires to enable CardDAV API (Google API)
{config, ...}: {
  accounts.contact = {
    basePath = "${config.xdg.dataHome}/contacts";
    accounts = {
      "google_contact_me_momee_mt" = {
        local = {
          type = "filesystem";
          path = "${config.xdg.dataHome}/contacts/google";
        };
        remote.type = "google_contacts";
        khard = {
          enable = true;
          addressbooks = [
            "default"
          ];
        };
        vdirsyncer = {
          enable = true;
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
          tokenFile = "${config.xdg.cacheHome}/vdirsyncer/google/me@momee.mt/contacts_token";
        };
      };
    };
  };

  assertions = let
    mkMessage = collection: package: "accounts.calendar: some accounts enable ${package}, but ${collection}.${package}.enable = false.";
  in [
    {
      assertion = config.programs.khal.enable;
      message = mkMessage "programs" "khard";
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
