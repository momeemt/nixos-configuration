{ pkgs, ... }:
{
  services.skhd = {
    enable = true;
    package = pkgs.skhd;
    skhdConfig = ''
      shift + cmd - return : open -na Terminal

      alt - x : yabai -m window --focus recent
      alt - h : yabai -m window --focus west
      alt - j : yabai -m window --focus south
      alt - k : yabai -m window --focus north
      alt - l : yabai -m window --focus east

      shift + alt - x : yabai -m window --swap recent
      shift + alt - h : yabai -m window --swap west
      shift + alt - j : yabai -m window --swap south
      shift + alt - k : yabai -m window --swap north
      shift + alt - l : yabai -m window --swap east

      shift + cmd - h : yabai -m window --warp west
      shift + cmd - j : yabai -m window --warp south
      shift + cmd - k : yabai -m window --warp north
      shift + cmd - l : yabai -m window --warp east

      shift + ctrl - a : yabai -m window --move rel:-20:0
      shift + ctrl - s : yabai -m window --move rel:0:20
      shift + ctrl - w : yabai -m window --move rel:0:-20
      shift + ctrl - d : yabai -m window --move rel:20:0

      shift + alt - a : yabai -m window --resize left:-20:0
      shift + alt - s : yabai -m window --resize bottom:0:20
      shift + alt - w : yabai -m window --resize top:0:-20
      shift + alt - d : yabai -m window --resize right:20:0

      shift + cmd - a : yabai -m window --resize left:20:0
      shift + cmd - s : yabai -m window --resize bottom:0:-20
      shift + cmd - w : yabai -m window --resize top:0:20
      shift + cmd - d : yabai -m window --resize right:-20:0

      alt - r : yabai -m space --rotate 90
      alt - y : yabai -m space --mirror y-axis
      alt - a : yabai -m space --toggle padding && yabai -m space --toggle gap
      alt - f : yabai -m window --toggle zoom-fullscreen
      shift + alt - f : yabai -m window --toggle native-fullscreen
      alt - e : yabai -m window --toggle split
      alt - t : yabai -m window --toggle float && yabai -m window --grid 4:4:1:1:2:2
    '';
  };
}

