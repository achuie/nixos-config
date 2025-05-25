{ inputs, outputs, lib, config, pkgs, ... }@args:

{
  imports = [
    ./common.nix
    ./config/sway
    ./config/wezterm
    ./config/tmux
    ./config/zsh
  ];
  nixpkgs = {
    overlays = [ inputs.nixgl.overlays.default ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
  home = {
    username = "achuie";
    homeDirectory = "/home/achuie";
    packages = with pkgs; [
      nixgl.nixGLIntel
    ];
  };

  home.stateVersion = "22.11";
}
