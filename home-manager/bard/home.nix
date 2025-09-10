{ inputs, outputs, lib, config, pkgs, ... }@args:

{
  imports = [
    ../achuie/config/tmux
    ../achuie/config/zsh
  ];
  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
  home = {
    username = "bard";
    homeDirectory = "/home/bard";
    packages = with pkgs; [
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      font-awesome

      inputs.achuie-nvim.packages.${pkgs.system}.default
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

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "25.11";
}
