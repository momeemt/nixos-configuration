{
  lib,
  pkgs,
  ...
}: {
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  i18n.defaultLocale = "ja_JP.UTF-8";
  console = {
    useXkbConfig = true;
  };

  time.timeZone = "Asia/Tokyo";

  networking.hostName = "shime";
  networking.firewall = {
    enable = true;
  };

  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
    "8.8.4.4"
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "copilot.vim"
      "google-chrome"
      "spotify"
      "discord"
      "todoist-electron"
      "vscode"
      "vscode-extension-ms-vscode-remote-remote-containers"
      "vscode-extension-ms-vscode-remote-remote-ssh"
      "vscode-extension-ms-vscode-remote-remote-ssh-edit"
    ];

  users.users.momeemt = {
    isNormalUser = true;
    extraGroups = ["wheel" "docker"];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = (import ../../system/ssh.nix).public_keys;
  };

  programs = {
    nix-ld.enable = true;
    zsh = {
      enable = true;
      enableCompletion = false;
    };
  };

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  services.vscode-server = {
    enable = true;
    enableFHS = true;
  };

  networking.firewall = {
    trustedInterfaces = ["tailscale0"];
  };

  system.stateVersion = "25.05";
}
