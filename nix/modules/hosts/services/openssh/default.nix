{
  services.openssh = {
    enable = true;
    startWhenNeeded = false;
    ports = [22];
    openFirewall = true;

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      StrictModes = true;
      X11Forwarding = false;
      UsePAM = false;
      AllowUsers = ["momeemt"];
      LogLevel = "VERBOSE";
    };

    extraConfig = ''
      ChallengeResponseAuthentication no
      PermitEmptyPasswords no
    '';
  };
}
