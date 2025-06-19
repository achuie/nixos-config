{ config, lib, pkgs, ... }:

{
  imports = [ ../../../lib/nullable.nix ];

  programs.tmux = {
    enable = true;
    package = config.nullable.wrap pkgs.tmux;
    extraConfig = builtins.readFile ./tmux.conf;
  };
}
