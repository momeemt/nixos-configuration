{
  config,
  pkgs,
  lib,
  ...
}: {
  sops = {
    age = {
      generateKey = true;
      keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
      sshKeyPaths = [];
    };
    defaultSopsFile = ../../../../secrets/secrets.enc.yml;

    # macOS LaunchAgent needs PATH to find getconf and newfs_hfs
    environment = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      PATH = lib.mkForce "/usr/bin:/usr/sbin:/bin:/sbin";
    };

    secrets = {
      google-me-momee-mt-client-id = {};
      google-me-momee-mt-client-secret = {};
      wakatime_api_key = {};
      "obsidian/api_key" = {};
      "github/claude_desktop_token" = {};
      "bluesky/momee_mt_password" = {};

      "ssh/masason.ssh" = {
        format = "binary";
        sopsFile = ../../../../secrets/ssh/masason.enc.ssh;
        key = "";
        mode = "0400";
      };
    };
  };
}
