# nixos-config

## Useful admin commands

### Print all gc-roots not part of the current system

```bash
$ sudo -i nix-store --gc --print-roots | grep -E -v '^(/nix/var|/run/current-system|/run/booted-system|/proc|{memory|{censored)'
```

### Store management

The command `nix-collect-garbage` is mostly an alias of `nix-store --gc`. That is, it deletes all unreachable store
objects in the Nix store to clean up your system. However, it provides two additional options, `--delete-old` and
`--delete-older-than`, which also delete old profiles. These options are the equivalent of running
`nix-env --delete-generations` with various augments on multiple profiles, prior to running `nix-collect-garbage` (or
just `nix-store --gc`) without any flags. The flakes equivalent is `nix store gc`.

### Why-depends for current profile

```bash
$ nix why-depends /nix/var/nix/profiles/per-user/$USER/profile $FLAKES_OUTPUT_OR_STORE_PATH
```

## Buoy

DigitalOcean droplet to achieve external port forwarding to my server behind a router I can't administer.

### Build base image

```bash
$ nix build .\#nixosConfigurations.buoy.config.system.build.digitalOceanImage
```
For uploading to DigitalOcean's image repo as a base for new droplets.

### NixOS remote build

```bash
$ nixos-rebuild switch --flake .\#buoy --target-host achuie@buoy --use-remote-sudo
```
Build locally on a NixOS system, then deploy to an existing droplet.

## Home Manager on Arch

- `nixGL` must be prepended to any invocation of a program that requires OpenGL, i.e., `$ nixGLIntel sway`.
- Neovim `spellfile` doesn't work?
- hyprlock needs to be installed natively to access PAM rules; Home Manager can still install the config by setting
`programs.hyprlock.package = null`
