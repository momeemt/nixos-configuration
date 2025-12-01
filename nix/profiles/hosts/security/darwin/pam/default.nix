{
  security.pam = {
    services = {
      sudo_local = {
        enable = true;
        reattach = false;
        watchIdAuth = true;
        # TODO: after introducing the mac mini, disable it.
        touchIdAuth = true;
      };
    };
  };
}
