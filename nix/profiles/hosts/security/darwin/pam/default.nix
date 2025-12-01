{
  security.pam = {
    services = {
      sudo_local = {
        enable = true;
        reattach = true;
        watchIdAuth = true;
        # TODO: after introducing the mac mini, disable it.
        touchIdAuth = true;
      };
    };
  };
}
