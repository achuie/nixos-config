{ config, lib, pkgs, ... }:

{
  imports = [ ../../../../lib/nullable.nix ];

  systemd.user.services.kanshi = {
    Unit.Description = "kanshi daemon";
    Service = {
      Type = "simple";
      Environment = [
        "WAYLAND_DISPLAY=wayland-1"
        "DISPLAY=:0"
      ];
      ExecStart = ''${config.nullable.wrap pkgs.kanshi}/bin/kanshi -c ${./kanshi_config}'';
    };
  };
}
