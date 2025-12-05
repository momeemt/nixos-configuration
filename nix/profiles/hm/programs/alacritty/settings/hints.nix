{pkgs, ...}: let
  open-nvim = pkgs.writeShellScriptBin "open-nvim" ''
    set -euo pipefail

    if [ "$#" -lt 1 ]; then
      echo "Usage: open-nvim <path>" >&2
      exit 1
    fi

    raw_path="$1"
    raw_path="$(echo $raw_path | xargs)" # trim whitespace
    tmux_cwd="$(${pkgs.tmux}/bin/tmux display-message -p -F '#{pane_current_path}' 2>/dev/null || pwd)"

    case "$raw_path" in
      "~" | "~/"* )
        raw_path="$HOME''${raw_path:1}"
        ;;
      /*)
        ;;
      *)
        raw_path="$tmux_cwd/$raw_path"
        ;;
    esac

    ${pkgs.tmux}/bin/tmux send-keys "nvim \"$raw_path\"" Enter
  '';
  exec-arg = pkgs.writeShellScriptBin "exec-arg" ''
    cmd="$1"
    ${pkgs.tmux}/bin/tmux send-keys "$cmd" Enter
  '';
in {
  programs.alacritty.settings.hints = {
    alphabet = "jfkdls;ahgurieowpq"; # default
    enabled = [
      {
        regex = "(https?://[^\\\\s]+)";
        post_processing = true;
        hyperlinks = true;
        command =
          if pkgs.stdenv.isDarwin
          then "open"
          else "xdg-open";
        binding = {
          key = "O";
          mods = "Control|Shift";
        };
      }
      (let
        root_regex = "/[^\\\\s]+";
        home_regex = "~[^/\\\\s]*/[^\\\\s]*";
        relative_regex = "\\\\.\\\\.?/[^\\\\s]*";
        plane_path_regex = "[^/\\\\s]+/[^\\\\s]*";
      in {
        regex = "(${root_regex}|${home_regex}|${relative_regex}|${plane_path_regex})";
        post_processing = true;
        command = "${open-nvim}/bin/open-nvim";
        binding = {
          key = "E";
          mods = "Control|Shift";
        };
      })
      {
        regex = "(nix log /nix/store/[^\\\\s]+)";
        post_processing = true;
        command = "${exec-arg}/bin/exec-arg";
        binding = {
          key = "L";
          mods = "Control|Shift";
        };
      }
    ];
  };
}
