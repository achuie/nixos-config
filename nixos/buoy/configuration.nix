# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, config, lib, pkgs, ... }:

{
  imports =
    [
      "${inputs.nixpkgs-stable}/nixos/modules/virtualisation/digital-ocean-image.nix"
    ];

  nixpkgs.hostPlatform = "x86_64-linux";
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

  users.users = {
    # Disable root login.
    root.hashedPassword = null;
    achuie = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPE/idtQ9eNHQJ2p7YiiHrDPGJxQnwXB2/grHhZoIRcx achuie@sprocket"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICPvDDEW8oP7z/1C8RRh9UI0SlSwodbktUQwXuEMcF8n achuie@svalbard"
      ];
    };
    whooie = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHe9UMcR8jqTjBky2R0q90QdQOF+b3gmOxXswiGuDLfX whooie@kestrel"
      ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  nix = {
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [ vim git lynx fd ripgrep rsync ];
    pathsToLink = [ "/libexec" ];
  };

  security.rtkit.enable = true;

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/porkbun@v0.3.1" ];
      hash = "sha256-g/Nmi4X/qlqqjY/zoG90iyP5Y5fse6Akr8exG5Spf08=";
    };
    globalConfig = ''    
      acme_dns porkbun {
        api_key {$APIKEY}
        api_secret_key {$APISECRETKEY}
      }
    '';
    virtualHosts = {
      "www.huie.dev" =
        let
          index = ''
            <html lang="en">
              <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Huie</title>
              </head>
              <h1 style="font-size:18rem\;text-align:center">許</h1>
              <br>
              <a href="https://andrew.huie.dev"><p style="text-align:center">andrew.huie.dev</p></a>
              <a href="https://will.huie.dev"><p style="text-align:center">will.huie.dev</p></a>
            </html>
          '';
        in
        {
          extraConfig = ''
            root * ${
              pkgs.runCommand "landing" {} ''
                mkdir "$out"
                echo "${index}" > "$out/index.html"
              ''
            }
            encode zstd gzip
            file_server
          '';
        };
      "huie.dev" = { extraConfig = "redir https://www.{host}{uri}"; };

      "andrew.huie.dev" = {
        extraConfig = ''
          root * /srv/andrew
          encode zstd gzip
          file_server
        '';
      };
      "www.andrew.huie.dev" = { extraConfig = "redir https://andrew.huie.dev{uri}"; };

      "will.huie.dev" = {
        extraConfig = ''
          root * /srv/will
          encode zstd gzip
          file_server
        '';
      };
      "www.will.huie.dev" = { extraConfig = "redir https://will.huie.dev{uri}"; };

      "isthmus.huie.dev" = {
        extraConfig = ''
          reverse_proxy * 127.0.0.1:8080
        '';
      };
    };
  };
  systemd.services.caddy.serviceConfig.EnvironmentFile = [ "/etc/secrets/porkbun_env" ];

  services.headscale = {
    enable = true;
    settings = {
      server_url = "https://isthmus.huie.dev:443";
      dns = {
        base_domain = "tailnet.huie.dev";
        nameservers.global = [ "1.1.1.1" ];
      };
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    authorizedKeysInHomedir = true;
    allowSFTP = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      GatewayPorts = "yes";
    };
  };

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 18131 80 443 ];
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
