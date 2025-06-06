# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, outputs, config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    efiInstallAsRemovable = true;
    enableCryptodisk = true;
    configurationLimit = 20;
  };
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.efi.canTouchEfiVariables = false;
  boot.initrd = {
    luks.devices.root = {
      device = "/dev/disk/by-uuid/c2eaa586-d09d-4d28-a582-1ae15c1ee236";
      preLVM = true;
      keyFile = "/keyfile0.bin";
      allowDiscards = true;
    };
    secrets = {
      "keyfile0.bin" = "/etc/secrets/initrd/keyfile0.bin";
    };
  };
  boot.initrd.kernelModules = [ "zfs" ];
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.zfs.allowHibernation = false;
  boot.zfs.devNodes = "/dev/disk/by-id";

  networking.hostName = "svalbard";
  networking.hostId = "1467377d";
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  time.timeZone = "Asia/Tokyo";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.fstrim.enable = true;
  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
  };

  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa = { enable = true; support32Bit = true; };
    pulse.enable = true;
    wireplumber.enable = true;
    socketActivation = true;
  };
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  users.users.achuie = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };
  programs.zsh = {
    enable = true;
    enableGlobalCompInit = false;
  };

  nix = {
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [ vim git lynx fd ripgrep rsync pciutils btop killall autossh ];
    pathsToLink = [ "/libexec" ];
  };

  security = {
    rtkit.enable = true;
    polkit = {
      enable = true;
      # extraConfig = ''
      #   polkit.addRule(function (action, subject) {
      #     if (
      #       subject.isInGroup("users") &&
      #       [
      #         "org.freedesktop.login1.reboot",
      #         "org.freedesktop.login1.reboot-multiple-sessions",
      #         "org.freedesktop.login1.power-off",
      #         "org.freedesktop.login1.power-off-multiple-sessions",
      #       ].indexOf(action.id) !== -1
      #     ) {
      #       return polkit.Result.YES;
      #     }
      #   });
      # '';
    };
    pam.services.hyprlock = {};
  };

  # Don’t shutdown when power button is short-pressed
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    HandlePowerKeyLongPress=poweroff
  '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    authorizedKeysInHomedir = true;
    allowSFTP = true;
    settings = { PasswordAuthentication = false; };
  };

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
  };

  systemd.services.buoyTunnel = {
    description = "Start reverse tunnel to buoy, and keep it alive.";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network.target" "network-online.target" "sshd.service" ];
    after = [ "network.target" "network-online.target" "sshd.service" ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.autossh}/bin/autossh -M 0 -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -N -R *:18131:localhost:22 \
        -i /home/achuie/.ssh/id_ed25519 achuie@164.90.245.94
      '';
    };
  };
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

