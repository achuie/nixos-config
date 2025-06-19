{ config, lib, pkgs, ... }:

{
  imports = [ ../../../../lib/nullable.nix ];

  programs.hyprlock = {
    enable = true;
    package = config.nullable.wrap pkgs.hyprlock;
    settings = {
      general = { ignore_empty_input = true; };
      background = [
        {
          path = "~/.background-image";
        }
      ];
      label = [
        {
          monitor = "";
          text = "$TIME";
          text_align = "left";
          color = "rgba(211, 215, 235, 1.0)";
          font_size = 240;
          font_family = "Fira Code Custom";
          position = "2%, 8%";
          halign = "left";
          valign = "bottom";
          shadow_passes = 3;
        }
        {
          monitor = "";
          text = ''cmd[update:43200000] echo "$(date +'%A, %B %e, %Y')"'';
          text_align = "left";
          color = "rgba(211, 215, 235, 1.0)";
          font_size = 60;
          font_family = "Fira Code Custom";
          position = "3%, 5%";
          halign = "left";
          valign = "bottom";
          shadow_passes = 3;
        }
      ];
      input-field = [
        {
          monitor = "";
          size = "20%, 5%";
          outline_thickness = 3;
          inner_color = "rgba(50, 52, 74, 0.7)";
          outer_color = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          check_color = "rgba(00ff99ee) rgba(ff6633ee) 120deg";
          fail_color = "rgba(ff6633ee) rgba(ff0066ee) 40deg";
          capslock_color = "rgba(ff9e64ee) rgba(ff7800ee) 20deg";
          font_color = "rgb(143, 143, 143)";
          font_family = "Iosevka Custom";
          placeholder_text = "<i>Password for <span foreground='##33ccff'>$USER</span></i>";
          fade_on_empty = false;
          rounding = 15;
          position = "0, 10%";
          halign = "center";
          valign = "center";
          shadow_passes = 2;
        }
      ];
    };
  };
}
