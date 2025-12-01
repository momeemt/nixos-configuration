{
  pkgs,
  siteLib,
  ...
}: {
  imports = [
    ../../profiles/sops
    ../../profiles/hosts/fonts
    ../../profiles/hosts/services/openssh
    ../../profiles/comin
    ../../profiles/hosts/system
    ./k8s
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  environment = {
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bash.enableCompletion
    pathsToLink = [
      "/share/bash-completion"
    ];
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  i18n.defaultLocale = "ja_JP.UTF-8";
  console = {
    useXkbConfig = true;
  };

  time.timeZone = "Asia/Tokyo";

  networking = {
    hostName = "shime";
    useNetworkd = true;
    firewall = {
      enable = true;
      trustedInterfaces = ["tailscale0"];
    };
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
      "8.8.4.4"
    ];
    interfaces = {
      enp4s0.useDHCP = false;
      br0.useDHCP = true;
    };
    bridges.br0.interfaces = ["enp4s0"];
  };

  nixpkgs.config.allowUnfree = true;

  users.users.momeemt = {
    isNormalUser = true;
    extraGroups = ["wheel" "docker" "libvirtd"];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = siteLib.publicKeys;
  };

  programs = {
    nix-ld.enable = true;
    zsh = {
      enable = true;
      enableCompletion = false;
    };
  };

  services = {
    tailscale = {
      enable = true;
      openFirewall = true;
    };

    vscode-server = {
      enable = true;
      enableFHS = true;
    };
  };

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
      };
    };

    libvirt = {
      enable = true;
      verbose = true;
      connections."qemu:///system".pools = null;
    };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = [pkgs.mesa];
  };
}
