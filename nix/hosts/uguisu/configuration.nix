{pkgs, ...}: {
  imports = [
    ./wallpapers.nix
    ../../profiles/sops
    ../../profiles/hosts
    ../../profiles/hosts/services/aerospace
  ];

  # Using DetermineSystems/nix-installer to install Nix
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;

  programs.bash = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = false;
  };

  users.users.momeemt = {
    name = "momeemt";
    home = "/Users/momeemt";
    shell = pkgs.zsh;
  };

  system = {
    primaryUser = "momeemt";
  };

  networking = {
    computerName = "uguisu";
    hostName = "uguisu";
    localHostName = "uguisu";
  };
}
