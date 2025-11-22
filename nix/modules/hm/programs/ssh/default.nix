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
    # enableDefaultConfig = true;

    includes = [
      config.sops.secrets."ssh/masason.ssh".path
    ];

    matchBlocks =
      {
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
        oshidori = sshMatchBlock {
          hostname = "oshidori";
          user = "momeemt";
          identityFile = "${sshHome}/nixos-configurations";
        };
        "github.com" = sshMatchBlock {
          hostname = "github.com";
          user = "git";
          identityFile = "${sshHome}/git";
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
