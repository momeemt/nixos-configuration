{pkgs}: let
  inherit (pkgs) lib;

  quartzSrc = pkgs.fetchFromGitHub {
    owner = "jackyzha0";
    repo = "quartz";
    rev = "d25a6eabf96751ffca56f8a8139272def7a65041";
    hash = "sha256-eYSMjvo4pduIYQwY9lPBj19yzPJmE0j2xh7x/IHBm94=";
  };

  obsidianSrc = lib.fileset.toSource {
    root = ./.;
    fileset =
      lib.fileset.difference
      ./.
      (lib.fileset.unions [
        ./.obsidian
        ./devShell.nix
        ./package.nix
        (lib.fileset.maybeMissing ./node_modules)
        (lib.fileset.maybeMissing ./package-lock.json)
        (lib.fileset.maybeMissing ./package.json)
        (lib.fileset.maybeMissing ./public)
      ]);
  };
in
  pkgs.buildNpmPackage {
    pname = "obsidian";
    version = "unstable-2026-05-18";

    src = quartzSrc;

    npmDepsHash = "sha256-7u+VlIx44B3/ivM9vLMIOn+e4TL4eS6B682vhS+Ikb4=";

    dontNpmBuild = true;

    installPhase = ''
      runHook preInstall

      rm -rf content
      mkdir -p content
      cp -R ${obsidianSrc}/. content/
      chmod -R u+w content
      rm -rf content/.quartz

      cp ${obsidianSrc}/.quartz/quartz.config.ts quartz.config.ts
      cp ${obsidianSrc}/.quartz/quartz.layout.ts quartz.layout.ts

      node quartz/bootstrap-cli.mjs build --directory content --output "$out"

      runHook postInstall
    '';

    meta = {
      description = "Static Quartz site for obsidian.momee.mt";
      homepage = "https://obsidian.momee.mt";
      license = lib.licenses.mit;
    };
  }
