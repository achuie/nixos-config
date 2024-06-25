{ config, lib, pkgs, ... }:

{
  services.picom = {
    enable = true;
    backend = "egl";
    fade = false;
    fadeDelta = 4;
    fadeSteps = [ 0.03 0.03 ];
    shadow = true;
    shadowOffsets = [ (-60) (-60) ];
    shadowOpacity = 0.75;
    shadowExclude = [ "I3_FLOATING_WINDOW@:c != 1" ];
    vSync = true;
    wintypes = {
      tooltip = {
        fade = true;
        shadow = true;
        opacity = 1.0;
        focus = true;
      };
      dock = {
        clip-shadow-above = true;
      };
    };
    settings = {
      blur-background = true;
      blur-background-fixed = false;
      blur-background-exclude = [ "class_g !*= 'wezterm'" ];
      blur = {
        method = "gaussian";
        size = 6;
        deviation = 8.0;
      };
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
      use-ewmh-active-win = true;
      detect-rounded-corners = true;
      detect-client-opacity = true;
      detect-transient = true;
      detect-client-leader = true;
      shadow-radius = 80;
    };
  };
}
