{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  claudeConfig = "Library/Application Support/Claude/claude_desktop_config.json";
  obsidianHost = "127.0.0.1";
  obsidianPort = "27124";
  obsidianApiKeyFile = config.sops.secrets."obsidian/api_key".path;
  mcpObsidianWrapper = pkgs.writeShellScript "mcp-obsidian-wrapper" ''
    set -eu
    export OBSIDIAN_API_KEY="$(cat ${obsidianApiKeyFile})"
    export OBSIDIAN_HOST="${obsidianHost}"
    export OBSIDIAN_PORT="${obsidianPort}"
    exec ${lib.getExe' pkgs.uv "uvx"} mcp-obsidian
  '';
in {
  home.file."${claudeConfig}" = {
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
      };
    };
  };
}
