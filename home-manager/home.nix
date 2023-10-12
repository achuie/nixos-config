{ inputs, outputs, lib, config, pkgs, ... }@args:

{
  imports = [
    ./config/i3/config.nix
    ./config/neovim/config.nix
    ./config/wezterm/config.nix
  ];
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
    packages = with pkgs; [ font-awesome args.firacode args.iosevka lm_sensors ];
  };

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "mujin";
    userEmail = "mujin@mujin.co.jp";
  };

  # services.gpg-agent = {
  #   enable = true;
  #   enableSshSupport = true;
  # };
  services.ssh-agent.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "22.11";
}
