# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, config, lib, pkgs, ... }:

{
  imports =
    [
      "${inputs.nixpkgs-stable}/nixos/modules/virtualisation/digital-ocean-image.nix"
    ];

  virtualisation.digitalOceanImage.compressionMethod = "bzip2";

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

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJQ1/DesaSOCyZALVMFENA3DORBXN/+hoGVjUo/SOo2h achuie@pinionwheel"
    ];
    # Generated with `mkpasswd` for use with DO web login
    hashedPassword = "$y$j9T$qdoZa2/tZ9/z01pUQtXgu.$IPXB8M04U8t.ybPMJsHResgJUBaTp9bv1ToU7q9UQn8";
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
    systemPackages = with pkgs; [ vim git lynx fd ripgrep rsync ];
    pathsToLink = [ "/libexec" ];
  };

  security.rtkit.enable = true;

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
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.

  swapDevices = [{
    device = "/swapfile";
    # In MB
    size = 1024 * 2;
  }];

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
  system.stateVersion = "24.05"; # Did you read the comment?

}

