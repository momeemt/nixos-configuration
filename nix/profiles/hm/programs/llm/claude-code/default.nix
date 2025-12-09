{
  pkgs,
  inputs,
  config,
  ...
}: {
  programs.claude-code = {
    enable = true;
    package = pkgs.claude-code;
    mcpServers = inputs.mcp-servers-nix.lib.mkConfig pkgs {
      programs = {
        context7.enable = true;
        nixos.enable = true;
      };
      settings.servers = {
        mcp-obsidian = {
          command = "${pkgs.lib.getExe' pkgs.nodejs "npx"}";
          args = [
            "-y"
            "mcp-obsidian"
            "${config.xdg.dataHome}/ghq/github.com/momeemt/note/note"
          ];
        };
      };
    };
  };
}
