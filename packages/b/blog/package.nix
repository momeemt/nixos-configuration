{
  pkgs,
  site ? "https://blog.momee.mt",
}: let
  inherit (pkgs) lib;

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./astro.config.mjs
      ./package-lock.json
      ./package.json
      ./public
      ./src
      ./tsconfig.json
    ];
  };
in
  pkgs.buildNpmPackage {
    pname = "blog";
    version = "unstable-2026-05-29";

    inherit src;

    npmDepsHash = "sha256-TiEV7y7uCGnUqO6q/2hCgDvgzurmRzPk9OLaaFm0X2I=";
    nodejs = pkgs.nodejs_24;

    BLOG_SITE = lib.removeSuffix "/" site;

    npmBuildScript = "build";

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"
      cp -R dist/. "$out"/

      runHook postInstall
    '';

    meta = {
      description = "Astro static blog for blog.momee.mt";
      homepage = "https://blog.momee.mt";
      license = lib.licenses.mit;
    };
  }
