# nixos-config

## Buoy

DigitalOcean droplet to achieve external port forwarding to my server behind a router I can't administer.

```
$ nix build .\#nixosConfigurations.buoy.config.system.build.digitalOceanImage
```
