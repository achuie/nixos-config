{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [ ./config/i3/config.nix ];
  nixpkgs = {
    overlays = [];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
  home = {
    username = "mujin";
    homeDirectory = "/home/mujin";
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.neovim.enable = true;
  programs.wezterm.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "22.11";
}
