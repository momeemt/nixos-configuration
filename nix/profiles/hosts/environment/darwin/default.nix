{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      tart
    ];
  };
}
