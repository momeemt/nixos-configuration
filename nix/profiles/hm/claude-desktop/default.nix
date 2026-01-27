{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  path = "Library/Application Support/Claude/claude_desktop_config.json";
  mcpObsidianWrapper = let
    host = "127.0.0.1";
    port = "27124";
    apiKeyFile = config.sops.secrets."obsidian/api_key".path;
  in
    pkgs.writeShellScript "mcp-obsidian-wrapper" ''
      set -eu
      export OBSIDIAN_API_KEY="$(cat ${apiKeyFile})"
      export OBSIDIAN_HOST="${host}"
      export OBSIDIAN_PORT="${port}"
      exec ${lib.getExe' pkgs.uv "uvx"} mcp-obsidian
    '';
  activitywatchMcp = pkgs.buildNpmPackage {
    pname = "activitywatch-mcp-server";
    version = "1.1.0-unstable-2025-03-28";
    src = pkgs.fetchFromGitHub {
      owner = "8bitgentleman";
      repo = "activitywatch-mcp-server";
      rev = "86d7cf2717880b2483e935aaaa96653418d69848";
      hash = "sha256-dpTzhsXT0ciW8sLY59TdoInOeOeUZUDWaDc76qKyW/M=";
    };
    npmDepsHash = "sha256-/UJOM4fgzo1MffYFhJasz7wePtK8J+mcUtgA2Q1ozfg=";
    npmBuildScript = "build";
    doCheck = false;
  };
  blueskyMcp = pkgs.buildNpmPackage {
    pname = "bluesky-mcp";
    version = "0-unstable-2025-01-26";
    src = pkgs.fetchFromGitHub {
      owner = "momeemt";
      repo = "bluesky-mcp";
      rev = "c4a17f1";
      hash = "sha256-X2eDToHqV70N1HpcnriUzxHQQHWnLxNMIXsM6rq/BEo=";
    };
    npmDepsHash = "sha256-0G8pDdjpJju8UgQ63OJkrmEybJylj9r2gMaspHZFthg=";
    nodejs = pkgs.nodejs_24;
    doCheck = false;
    npmBuildScript = "build";
    postBuild = ''
      cp -r dist $TMPDIR/dist
    '';
    postInstall = ''
      cp -r $TMPDIR/dist $out/lib/node_modules/@semihberkay/bluesky-mcp/
    '';
  };
  mcpBlueskyWrapper = let
    identifier = "momee.mt";
    passwordFile = config.sops.secrets."bluesky/momee_mt_password".path;
  in
    pkgs.writeShellScript "mcp-bluesky-wrapper" ''
      set -eu
      export BLUESKY_IDENTIFIER="${identifier}"
      export BLUESKY_PASSWORD="$(cat ${passwordFile})"
      exec ${blueskyMcp}/bin/bluesky-mcp
    '';
in {
  home.file."${path}" = {
    source = inputs.mcp-servers-nix.lib.mkConfig pkgs {
      programs = {
        context7.enable = true;
        time.enable = true;
        memory.enable = true;
        serena.enable = true;
        github = {
          enable = true;
          envFile = config.sops.secrets."github/claude_desktop_token".path;
        };
        codex.enable = true;
      };
      settings.servers = {
        mcp-obsidian = {
          command = "${mcpObsidianWrapper}";
          args = [];
        };
        activitywatch = {
          command = "${activitywatchMcp}/bin/activitywatch-mcp-server";
          args = [];
        };
        bluesky = {
          command = "${mcpBlueskyWrapper}";
          args = [];
        };
      };
    };
  };
}
