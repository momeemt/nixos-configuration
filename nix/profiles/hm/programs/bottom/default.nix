{pkgs, ...}: {
  programs.bottom = {
    enable = true;
    package = pkgs.bottom;
    settings = {
      flags = {
        temperature_type = "celsius";
      };
    };
  };
}
