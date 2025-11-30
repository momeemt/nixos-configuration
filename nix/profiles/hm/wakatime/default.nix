{
  config,
  lib,
  ...
}: {
  home.activation.wakatimeConfig = lib.hm.dag.entryAfter ["sops-nix"] ''
    cfg_dir="$HOME/.config/wakatime"
    mkdir -p "$cfg_dir"
    api_key="$(cat "${config.sops.secrets.wakatime_api_key.path}")"

    cat >"$cfg_dir/.wakatime.cfg" <<EOF
    [settings]
    debug = false
    hidefilenames = false
    ignore =
        COMMIT_EDITMSG$
        PULLREQ_EDITMSG$
        MERGE_MSG$
        TAG_EDITMSG$
    api_key = $api_key
    EOF
  '';

  home.sessionVariables = {
    WAKATIME_HOME = "${config.xdg.configHome}/wakatime";
  };
}
