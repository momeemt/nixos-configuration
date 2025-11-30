{
  services.aerospace.settings.mode.main.binding = let
    workspaces = builtins.listToAttrs (
      map (n: let
        ns = builtins.toString n;
      in {
        name = "alt-${ns}";
        value = "workspace ${ns}";
      }) (builtins.genList (i: i + 1) 9)
    );
    move-node-to-workspaces = builtins.listToAttrs (
      map (n: let
        ns = builtins.toString n;
      in {
        name = "alt-shift-${ns}";
        value = "move-node-to-workspace ${ns}";
      }) (builtins.genList (i: i + 1) 9)
    );
  in
    {
      alt-slash = "layout tiles horizontal vertical";
      alt-comma = "layout accordion horizontal vertical";
      alt-h = "focus left";
      alt-j = "focus down";
      alt-k = "focus up";
      alt-l = "focus right";
      alt-shift-h = "move left";
      alt-shift-j = "move down";
      alt-shift-k = "move up";
      alt-shift-l = "move right";
      alt-minus = "resize smart -50";
      alt-equal = "resize smart +50";
      alt-tab = "workspace-back-and-forth";
      alt-shift-tab = "move-workspace-to-monitor --wrap-around next";
      alt-shift-semicolon = "mode service";
    }
    // workspaces
    // move-node-to-workspaces;
}
