{ inputs, outputs, lib, config, pkgs, ... }@args:

{
  imports = [
    # ./config/i3
    ./config/sway
    ./config/wezterm
    ./config/tmux
    ./config/zsh
    ./config/picom
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
      args.firacode
      args.iosevka
      noto-fonts
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      font-awesome

      inputs.achuie-nvim.packages.${pkgs.system}.default
      lm_sensors
      skim
      pulsemixer
      maim
      feh
      redshift
      mpv
    ];
    pointerCursor = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      gtk.enable = true;
      sway.enable = true;
    };
  };

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      lfs.enable = true;
      userName = "achuie";
      userEmail = "achuie@protonmail.com";
    };
    firefox = {
      enable = true;
      policies = {
        OfferToSaveLogins = false;
        Permissions = {
          Notifications = {
            BlockNewRequests = true;
          };
        };
      };
    };
  };

  fonts.fontconfig.enable = true;

  # services.gpg-agent = {
  #   enable = true;
  #   enableSshSupport = true;
  # };
  services.ssh-agent.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "22.11";
}
