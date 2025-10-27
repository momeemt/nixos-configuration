{
  sops = {
    age = {
      generateKey = true;
      keyFile = "/var/lib/sops-nix/key.txt";
    };
    defaultSopsFile = ../../secrets/secrets.yml.enc;
    secrets = {
      momeemt-password = {
        neededForUsers = true;
      };

      k8s-bootstrap-token = {};

      "cloudflared/emu.json" = {
        format = "json";
        sopsFile = ../../secrets/cloudflared/emu.json.enc;
        key = "";
        mode = "0400";
      };

      "cloudflared/emu-desktop.json" = {
        format = "json";
        sopsFile = ../../secrets/cloudflared/emu-desktop.json.enc;
        key = "";
        mode = "0400";
      };

      "k8s/ca.key" = {
        format = "binary";
        sopsFile = ../../secrets/k8s/ca.key.enc;
        mode = "0400";
      };
    };
  };
}
