{ inputs, outputs, lib, config, pkgs, ... }@args:

{
  imports = [
    ./config/i3
    ./config/neovim
    ./config/wezterm
    ./config/tmux
    ./config/zsh
  ];
  nixpkgs = {
    overlays = [];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
  home = {
    username = "achuie";
    homeDirectory = "/home/achuie";
    packages = with pkgs; [
      font-awesome
      args.firacode
      args.iosevka
      lm_sensors
      skim
    ];
  };

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "achuie";
    userEmail = "achuie@protonmail.com";
  };

  # services.gpg-agent = {
  #   enable = true;
  #   enableSshSupport = true;
  # };
  services.ssh-agent.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "22.11";
}
