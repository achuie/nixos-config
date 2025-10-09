{ inputs, outputs, lib, config, pkgs, ... }@args:

{
  imports = [
  ];
  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
  home = {
    username = "achuietx";
    homeDirectory = "/home/achuietx";
    packages = with pkgs; [
      args.iosevka

      inputs.achuie-nvim.packages.${pkgs.system}.nvim
      skim
      tmux
      wezterm

      slack
      claude-code
    ];
    file = {
      ".zsh/.zshrc".source = ./dots/zsh/zshrc;
      ".zsh/prompts".source = ./dots/zsh/prompts;
      ".zsh/functions/prompt_achuie_setup".source = ./dots/zsh/prompts/achuie.zsh;
    };
    pointerCursor = {
      enable = true;
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };
  xdg.configFile = {
    "tmux/tmux.conf".source = ./dots/tmux/tmux.conf;
    "wezterm/wezterm.lua".source = ./dots/wezterm/wezterm.lua;
  };

  programs = {
    home-manager.enable = true;
    zsh = {
      enable = true;
      envExtra = builtins.readFile ./dots/zsh/zshenv;
    };
    git = {
      enable = true;
      userName = "achuietx";
      userEmail = "andrew.huie@tx-inc.com";
    };
    firefox = {
      enable = true;
      policies = {
        OfferToSaveLogins = false;
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

  home.stateVersion = "25.05";
}
