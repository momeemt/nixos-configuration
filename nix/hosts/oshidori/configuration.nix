{
  pkgs,
  siteLib,
  ...
}: {
  imports = [
    ../../profiles/hosts
    ../../profiles/hosts/services/openssh
    ../../profiles/hosts/services/resolved
    ../../profiles/comin
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  boot.loader = {
    systemd-boot.enable = false;
    grub = {
      enable = true;
      device = "/dev/nvme0n1";
    };
  };

  networking = {
    hostName = "oshidori";
    networkmanager.enable = false;
    wireless.enable = true;
    firewall.trustedInterfaces = ["tailscale0"];
  };

  nixpkgs.config.allowUnfree = true;

  users.users.momeemt = {
    isNormalUser = true;
    extraGroups = ["wheel" "docker"];
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
    xserver.enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    xrdp = {
      enable = true;
      defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";
      openFirewall = true;
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    tailscale = {
      enable = true;
      openFirewall = true;
    };

    vscode-server = {
      enable = true;
      enableFHS = true;
    };
  };

  # https://github.com/NixOS/nixpkgs/issues/100390
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.login1.suspend" ||
            action.id == "org.freedesktop.login1.suspend-multiple-sessions" ||
            action.id == "org.freedesktop.login1.hibernate" ||
            action.id == "org.freedesktop.login1.hibernate-multiple-sessions")
        {
            return polkit.Result.NO;
        }
    });
  '';

  environment = {
    variables = {
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
      GLFW_IM_MODULE = "ibus";
    };

    gnome.excludePackages =
      (with pkgs; [
        gnome-photos
        gnome-tour
      ])
      ++ (with pkgs; [
        cheese
        gnome-music
        gnome-terminal
        gedit
        epiphany
        geary
        evince
        gnome-characters
        totem
        tali
        iagno
        hitori
        atomix
      ]);
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
