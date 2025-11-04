# It requires to enable CardDAV API (Google API)
{config, ...}: {
  programs.khard.enable = true;

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
}
