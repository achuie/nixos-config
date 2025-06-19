{ config, lib, pkgs, ... }:

{
  imports = [ ../../../../lib/nullable.nix ];

  services.dunst = {
    enable = true;
    package = config.nullable.wrap pkgs.dunst;
    iconTheme = {
      package = config.home.pointerCursor.package or pkgs.adwaita-icon-theme;
      name = config.home.pointerCursor.name or "Adwaita";
    };
    configFile = "${./dunstrc}";
  };
}
