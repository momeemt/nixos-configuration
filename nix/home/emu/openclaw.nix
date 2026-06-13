{
  pkgs,
  inputs,
  systemConfig,
  ...
}: {
  imports = [
    inputs.nix-openclaw.homeManagerModules.openclaw
  ];

  site.home = {
    username = "openclaw";
    extraPackages = with pkgs; [
      gogcli
      gh
    ];
  };

  programs.openclaw = {
    enable = true;
    reloadScript.enable = true;
    runtimePlugins = [
      "discord"
      "codex"
    ];

    bundledPlugins.gogcli = {
      enable = true;
      config.env.GOG_KEYRING_PASSWORD = systemConfig.sops.secrets."openclaw/gog-keyring-password".path;
    };

    workspace.bootstrapFiles = {
      agents = ./openclaw-workspace/AGENTS.md;
      soul = ./openclaw-workspace/SOUL.md;
      tools = ./openclaw-workspace/TOOLS.md;
      identity = ./openclaw-workspace/IDENTITY.md;
      user = ./openclaw-workspace/USER.md;
      heartbeat = ./openclaw-workspace/HEARTBEAT.md;
    };

    environment = {
      DISCORD_BOT_TOKEN = systemConfig.sops.secrets."openclaw/discord-bot-token".path;
      GOG_KEYRING_PASSWORD = systemConfig.sops.secrets."openclaw/gog-keyring-password".path;
      OPENCLAW_GOOGLE_OAUTH_CLIENT_JSON = systemConfig.sops.secrets."openclaw/google-oauth-client.json".path;
      OPENCLAW_GATEWAY_TOKEN = systemConfig.sops.secrets."openclaw/gateway-token".path;
    };

    config = {
      gateway.mode = "local";

      agents.defaults.model.primary = "openai/gpt-5.5";

      channels = {
        defaults.groupPolicy = "allowlist";
        discord = {
          enabled = true;
          token = {
            source = "env";
            provider = "default";
            id = "DISCORD_BOT_TOKEN";
          };
          groupPolicy = "allowlist";
          guilds."1458799076836638831" = {
            requireMention = true;
            users = [
              "367903485074735105"
            ];
          };
          dmPolicy = "allowlist";
          allowFrom = [
            "discord:367903485074735105"
          ];
          streaming = {
            mode = "progress";
            progress.commandText = "status";
          };
        };
      };

      plugins.entries.codex = {
        enabled = true;
        config.appServer = {
          mode = "guardian";
          defaultWorkspaceDir = "/home/openclaw/.openclaw/workspace";
        };
      };
    };
  };
}
