{pkgs, ...}: {
  programs.less = {
    enable = true;
    package = pkgs.less;

    # configurations for NixOS unsatable
    # config = ''
    #   #command
    #   q quit
    #   r repaint-flush
    # '';
    #
    # options = {
    #   RAW-CONTROL-CHARS = true;
    #   quit-if-one-screen = true;
    #   no-init = true;
    # };
  };
}
