{config, ...}: {
  accounts.email = {
    maildirBasePath = "${config.xdg.dataHome}/mail";
    accounts.main = {
      address = "me@momee.mt";
      realName = "Mutsuha Asada";
      primary = true;
      flavor = "gmail.com";

      smtp = {
        host = "smtp.gmail.com";
        port = 587;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };
      msmtp.enable = true;

      lieer = {
        enable = true;
        sync.enable = true;
        settings = {
          maildir = ".";
          ignore_empty_history = true;
          ignore_remote_labels = [];
        };
      };

      notmuch.enable = true;
      aerc.enable = true;
      maildir.path = "main";
    };
  };

  assertions = let
    mkMessage = package: "accounts.email: some accounts enable ${package}, but programs.${package}.enable = false.";
  in [
    {
      assertion = config.programs.aerc.enable;
      message = mkMessage "aerc";
    }
    {
      assertion = config.programs.lieer.enable;
      message = mkMessage "lieer";
    }
    {
      assertion = config.programs.notmuch.enable;
      message = mkMessage "notmuch";
    }
  ];
}
