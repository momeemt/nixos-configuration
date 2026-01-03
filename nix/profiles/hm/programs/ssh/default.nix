{
  config,
  pkgs,
  siteLib,
  ...
}: let
  sshHome = "${config.home.homeDirectory}/.ssh";
  sshMatchBlock = cfg:
    {
      port = 22;
      identitiesOnly = true;
      extraOptions = {
        "PasswordAuthentication" = "no";
      };
    }
    // cfg;
  coins-ce = name: {
    hostname = "${name}.coins.tsukuba.ac.jp";
    user = "s2210897";
    identityFile = "${sshHome}/coins-momeemt";
  };
in {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    includes = [
      config.sops.secrets."ssh/masason.ssh".path
    ];

    matchBlocks =
      {
        "*" = {
          forwardAgent = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          compression = false;
          addKeysToAgent = "no";
          hashKnownHosts = false;
          userKnownHostsFile = "${sshHome}/known_hosts";
          controlMaster = "no";
          controlPath = "${sshHome}/master-%r@%n:%p";
          controlPersist = "no";
        };
        emu-cloudflared = sshMatchBlock {
          hostname = "emu.momee.mt";
          identityFile = "${sshHome}/nixos-configurations";
          proxyCommand = "${pkgs.cloudflared}/bin/cloudflared access ssh --hostname %h";
          port = null;
        };
        emu = sshMatchBlock {
          hostname = siteLib.ip.emu;
          identityFile = "${sshHome}/nixos-configurations";
          user = "momeemt";
        };
        emu-tailscale = sshMatchBlock {
          hostname = "emu";
          identityFile = "${sshHome}/nixos-configurations";
          user = "momeemt";
        };
        shime = sshMatchBlock {
          hostname = siteLib.ip.shime;
          identityFile = "${sshHome}/nixos-configurations";
          user = "momeemt";
        };
        kube-master = sshMatchBlock {
          hostname = siteLib.ip.kube-master;
          identityFile = "${sshHome}/nixos-configurations";
          user = "ubuntu";
        };
        kube-worker-emu-1 = sshMatchBlock {
          hostname = siteLib.ip.kube-worker-emu-1;
          identityFile = "${sshHome}/nixos-configurations";
          user = "ubuntu";
        };
        kube-worker-emu-2 = sshMatchBlock {
          hostname = siteLib.ip.kube-worker-emu-2;
          identityFile = "${sshHome}/nixos-configurations";
          user = "ubuntu";
        };
        kube-worker-shime-1 = sshMatchBlock {
          hostname = siteLib.ip.kube-worker-shime-1;
          identityFile = "${sshHome}/nixos-configurations";
          user = "ubuntu";
        };
        coins-shinkan = sshMatchBlock {
          hostname = "violet01.coins.tsukuba.ac.jp";
          user = "shinkan";
          identityFile = "${sshHome}/coins-shinkan";
        };
        zengaku = sshMatchBlock {
          hostname = "icho01.u.tsukuba.ac.jp";
          user = "s2210897";
          identityFile = "${sshHome}/zengaku";
        };
        oshidori-tailscale = sshMatchBlock {
          hostname = "oshidori";
          user = "momeemt";
          identityFile = "${sshHome}/nixos-configurations";
        };
        "github.com" = sshMatchBlock {
          hostname = "github.com";
          user = "git";
          identityFile = "${sshHome}/git";
        };
        kitsutsuki = sshMatchBlock {
          hostname = siteLib.ip.kitsutsuki;
          user = "momeemt";
          identityFile = "${sshHome}/keys/kitsutsuki";
        };
        kitsutsuki-tailscale = sshMatchBlock {
          hostname = "kitsutsuki";
          user = "momeemt";
          identityFile = "${sshHome}/keys/kitsutsuki";
        };
      }
      // builtins.listToAttrs (
        map (name: {
          name = "coins-momeemt-${name}";
          value = coins-ce name;
        }) [
          "violet01"
          "violet03"
          "azalea05"
        ]
      );
  };
}
