# /etc/nixos

_README is WIP._

This repository contains my system configs. I use [Nix](https://nixos.org/) to
manage my systems: NixOS whenever possible, and Nix+Home Manager otherwise.

I use [Nix Flakes](https://nixos.wiki/wiki/Flakes). All NixOS and Home Manager
configurations are specified as outputs in the `flake.nix` file.

The system configurations can be activated with the following commands:

```bash
$ home-manager switch --flake /etc/nixos/#host        # To activate Home Manager.
$ sudo nixos-rebuild switch --flake /etc/nixos/#host  # To activate NixOS.
```

There are currently four hosts, all on NixOS:

- `splendor`: My [custom built desktop](https://pcpartpicker.com/user/meowihaveagrape/saved/wKxRK8).
- `haiqin`: My primary laptop, a Thinkpad X1 Carbon 9th Gen.
- `neptune`: My secondary laptop, a Thinkpad X1 Carbon 5th Gen.
- `zen`: An OVH server.

I also write software for myself when I find the preexisting solutions to not
meet my needs. The pieces of software that are useful primarily to only myself
are kept in this repository, and they are:

- [Backup Scripts](./pkgs/backup-scripts): Manage my local and remote backups.
- [File Uploader](./pkgs/file-uploader): Upload files to various image and file
  hosting services.
- [EXIF & Last Modified Syncer](./pkgs/exif-mtime-sync/): Sync an image's EXIF
  Created Date and filesystem Last Modified time.

# Directory Structure

This repository is organized into the following directories:

- `home` contains bundles of configurations for Home Manager. Each host
  selects the bundles that apply to it
- `os` contains NixOS configurations for each host on NixOS. 
- `pkgs` contains an overlaid `nixpkgs` that's shared between all configs.
  My patches to `nixpkgs` are applied here, and my custom software is
  stored here.
- `services` contains some of general Nomad & Consul specs that are not tied to
  another project of mine.

`flake.nix` is the entrypoint for `home`, `os`, and `pkgs`.

# Networking

All hosts are connected to each other via Tailscale VPN. The Tailscale ACL can
be found [here](./tailscale.policy.hujson).
