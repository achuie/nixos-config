{ config, lib, pkgs, ... }:

{
  imports = [ ../../../lib/nullable.nix ];

  programs.wezterm = {
    enable = true;
    package = config.nullable.wrap pkgs.wezterm;
    extraConfig = builtins.readFile ./wezterm.lua;
  };
}
