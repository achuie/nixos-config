{ inputs, outputs, lib, config, pkgs, ... }@args:

{
  imports = [
    # ./config/i3
    ./config/sway
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
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
  };

  programs = {
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

  home.stateVersion = "22.11";
}
