{ config, lib, pkgs, ... }:

{
  imports = [ ../../../lib/nullable.nix ];

  swayimg = {
    enable = true;
    package = config.nullable.wrap pkgs.swayimg;
    settings = { viewer = { window = "#ffffffff"; }; };
  };
}
