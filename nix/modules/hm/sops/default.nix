{config, ...}: {
  sops = {
    age = {
      generateKey = true;
      keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
      sshKeyPaths = [];
    };
    defaultSopsFile = ../../../../secrets/secrets.enc.yml;
    secrets = {
      google-me-momee-mt-client-id = {};
      google-me-momee-mt-client-secret = {};

      "ssh/masason.ssh" = {
        format = "binary";
        sopsFile = ../../../../secrets/ssh/masason.enc.ssh;
        key = "";
        mode = "0400";
      };
    };
  };
}
