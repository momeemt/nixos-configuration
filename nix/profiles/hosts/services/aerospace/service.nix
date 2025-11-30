{
  services.aerospace.settings.mode.service.binding = let
    return-main-mode = cmds: cmds ++ ["mode main"];
  in {
    esc = return-main-mode ["reload-config"];
    r = return-main-mode ["flatten-workspace-tree"];
    f = return-main-mode ["layout floating tiling"];
    backspace = return-main-mode ["close-all-windows-but-current"];

    alt-shift-h = return-main-mode ["join-with left"];
    alt-shift-j = return-main-mode ["join-with down"];
    alt-shift-k = return-main-mode ["join-with up"];
    alt-shift-l = return-main-mode ["join-with right"];

    down = "volume down";
    up = "volume up";
    shift-down = return-main-mode ["volume set 0"];
  };
}
