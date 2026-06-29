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

      node <<'EOF'
      const fs = require("fs")
      const path = require("path")

      const root = "content"

      const slug = (value) =>
        clean(value)
          .replace(/\.md$/i, "")
          .replace(/\\/g, "/")
          .split("/")
          .map((segment) => segment.trim().replace(/\s+/g, "-"))
          .join("/")

      const isSameSlug = (left, right) =>
        left.toLowerCase() === right.toLowerCase()

      const walk = (dir) => {
        const entries = fs.readdirSync(dir, {withFileTypes: true})
        return entries.flatMap((entry) => {
          const target = path.join(dir, entry.name)
          return entry.isDirectory() ? walk(target) : [target]
        })
      }

      const clean = (value) => {
        const trimmed = value.trim()
        if (
          (trimmed.startsWith('"') && trimmed.endsWith('"')) ||
          (trimmed.startsWith("'") && trimmed.endsWith("'"))
        ) {
          return trimmed.slice(1, -1)
        }

        return trimmed
      }

      const firstAlias = (frontmatter) => {
        const lines = frontmatter.split(/\r?\n/)

        for (const line of lines) {
          const scalar = line.match(/^aliases:\s*(.+?)\s*$/)
          if (scalar && scalar[1] !== "[]") {
            return clean(scalar[1])
          }
        }

        const aliasIndex = lines.findIndex((line) => /^aliases:\s*$/.test(line))
        if (aliasIndex === -1) {
          return null
        }

        for (const line of lines.slice(aliasIndex + 1)) {
          if (/^\S/.test(line)) {
            break
          }

          const item = line.match(/^\s*-\s+(.+?)\s*$/)
          if (item) {
            return clean(item[1])
          }
        }

        return null
      }

      const withoutSelfAliases = (frontmatter, canonicalSlug) => {
        const lines = frontmatter.split(/\r?\n/)
        const next = []

        for (let index = 0; index < lines.length; index += 1) {
          const scalar = lines[index].match(/^aliases:\s*(.+?)\s*$/)
          if (scalar) {
            if (scalar[1] === "[]" || !isSameSlug(slug(scalar[1]), canonicalSlug)) {
              next.push(lines[index])
            }
            continue
          }

          if (!/^aliases:\s*$/.test(lines[index])) {
            next.push(lines[index])
            continue
          }

          const headerIndex = next.length
          let keptItems = 0
          next.push(lines[index])

          index += 1
          for (; index < lines.length; index += 1) {
            if (/^\S/.test(lines[index])) {
              index -= 1
              break
            }

            const item = lines[index].match(/^(\s*-\s+)(.+?)(\s*)$/)
            if (!item || !isSameSlug(slug(item[2]), canonicalSlug)) {
              next.push(lines[index])
              if (item) {
                keptItems += 1
              }
            }
          }

          if (keptItems === 0) {
            next.splice(headerIndex, 1)
          }
        }

        return next.join("\n")
      }

      for (const file of walk(root)) {
        if (!file.endsWith(".md")) {
          continue
        }

        const text = fs.readFileSync(file, "utf8")
        if (!text.startsWith("---\n")) {
          continue
        }

        const end = text.indexOf("\n---", 4)
        if (end === -1) {
          continue
        }

        const frontmatter = text.slice(4, end)
        const canonicalSlug = slug(path.relative(root, file))
        const nextFrontmatter = withoutSelfAliases(frontmatter, canonicalSlug)
        const title =
          /^title:\s*/m.test(nextFrontmatter) ? null : firstAlias(frontmatter)

        fs.writeFileSync(
          file,
          `---\n''${title ? `title: ''${JSON.stringify(title)}\n` : ""}''${nextFrontmatter}''${text.slice(end)}`,
        )
      }
      EOF

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
