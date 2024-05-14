{ inputs, outputs, lib, config, pkgs, ... }@args:

{
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ./config/i3
    ./config/neovim
    ./config/wezterm
    ./config/tmux
    ./config/zsh
  ];
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

  services.flatpak = {
    packages = [
      { appId = "org.mozilla.firefox"; origin = "flathub"; }
    ];
    overrides = {
      "org.mozilla.firefox".Context = {
        filesystems = [ "xdg-download" ];
        nofilesystem = "host:reset";
      };
    };
  };

  # services.gpg-agent = {
  #   enable = true;
  #   enableSshSupport = true;
  # };
  services.ssh-agent.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "22.11";
}
