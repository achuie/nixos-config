{ config, lib, pkgs, swaypkg, ... }:

{
  imports = [ ../../../../lib/nullable.nix ];

  services.swayidle = {
    enable = true;
    package = config.nullable.wrap pkgs.swayidle;
    extraArgs = [ "-w" ];
    events = [];
    timeouts = [
      {
        timeout = 15;
        command = ''if ${config.nullable.wrap pkgs.procps}/bin/pgrep -x hyprlock; then ${swaypkg}/bin/swaymsg "output * power off"; fi'';
        resumeCommand = ''${swaypkg}/bin/swaymsg "output * power on"'';
      }
    ];
  };
}
