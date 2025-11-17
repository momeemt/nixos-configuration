{pkgs, ...}: {
  site.services.set-wallpapers = {
    enable = true;
    wallpapers = [
      # ponyo
      (pkgs.fetchurl {
        url = "https://www.ghibli.jp/gallery/ponyo022.jpg";
        hash = "sha256-EIhk0bIak+IuQ1BJsm6g8Kxld3JBfhXESC/lV/l3xPI=";
      })
      (pkgs.fetchurl {
        url = "https://www.ghibli.jp/gallery/ponyo028.jpg";
        hash = "sha256-OTRrZAtyrOi7Ooj7eoXoTyWXSTenX1psi5EerLI3S4o=";
      })
      (pkgs.fetchurl {
        url = "https://www.ghibli.jp/gallery/ponyo031.jpg";
        hash = "sha256-RxU25hOoo/QVaN8QvIx5bUU5V13g6aJHOIq+rVJiFlI=";
      })
      # kokurikozaka
      (pkgs.fetchurl {
        url = "https://www.ghibli.jp/gallery/kokurikozaka031.jpg";
        hash = "sha256-84qOKYVJkt5yUD8BC2m8jhOcA1GpbpudgdKwND4doN0=";
      })
      (pkgs.fetchurl {
        url = "https://www.ghibli.jp/gallery/kokurikozaka012.jpg";
        hash = "sha256-dVMQ2pirOw8FjlAVaTT/5H49JqS7oRFmAvnqALDKb+Y=";
      })
      (pkgs.fetchurl {
        url = "https://www.ghibli.jp/gallery/kokurikozaka017.jpg";
        hash = "sha256-Tpocs6gnkHscATGY4PsOcxeaYt8v+TauZXggrS+a9yA=";
      })
      # chihiro
      (pkgs.fetchurl {
        url = "https://www.ghibli.jp/gallery/chihiro048.jpg";
        hash = "sha256-BodnZXcZBlZ8IOwcvw7cAvdBgqRYyrCj1I0dUa4+R4g=";
      })
      # umi
      (pkgs.fetchurl {
        url = "https://www.ghibli.jp/images/umi1.jpg";
        hash = "sha256-SUUdKgLbIp17JKsKwRs5bNsyN+ECqep+0OS3hXu1HQo=";
      })
    ];
  };
}
