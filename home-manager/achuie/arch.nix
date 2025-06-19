{ inputs, outputs, lib, config, pkgs, ... }@args:

{
  imports = [
    ./config/sway
    ./config/wezterm
    ./config/tmux
    ./config/zsh

    ../lib/nullable.nix
  ];

  nullable.enable = true;

  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
  home = {
    username = "achuie";
    homeDirectory = "/home/achuie";
    pointerCursor = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      gtk.enable = true;
      sway.enable = true;
    };
  };

  programs = {
    git = {
      enable = true;
      userName = "achuie";
      userEmail = "achuie@protonmail.com";
    };
  };

  services.ssh-agent.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "22.11";
}
