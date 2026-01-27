{
  pkgs,
  siteLib,
  ...
}: let
  awPackage =
    if siteLib.isLinux
    then pkgs.activitywatch
    else pkgs.brewCasks.activitywatch;

  commonWatchers = {
    aw-watcher-afk = {
      package = awPackage;
    };
    aw-watcher-window = {
      package = awPackage;
    };
  };
in
  if siteLib.isLinux
  then {
    services.activitywatch = {
      enable = true;
      package = pkgs.aw-server-rust;
      watchers = commonWatchers;
    };
  }
  else {
    site.services.activitywatch = {
      enable = true;
      package = awPackage;
      watchers = commonWatchers;
    };
  }
