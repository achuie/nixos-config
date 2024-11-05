# nixos-config

## Buoy

DigitalOcean droplet to achieve external port forwarding to my server behind a router I can't administer.

### Build base image

```
$ nix build .\#nixosConfigurations.buoy.config.system.build.digitalOceanImage
```
For uploading to DigitalOcean's image repo as a base for new droplets.

### NixOS remote build

```
$ nixos-rebuild switch --flake .\#buoy --target-host root@<IP address>
```
Build locally on a NixOS system, then deploy to an existing droplet.
