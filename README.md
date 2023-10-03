# /etc/nixos

_README is WIP._

This repository contains my system configs. I use [Nix](https://nixos.org/) to
manage my systems, with NixOS whenever possible, and Home Manager otherwise.

I use [Nix Flakes](https://nixos.wiki/wiki/Flakes). All NixOS and Home Manager
configurations are specified as outputs in the `flake.nix` file.

The system configurations can be activated with the following commands:

```bash
$ home-manager switch --flake /etc/nixos/#host        # To activate Home Manager.
$ sudo nixos-rebuild switch --flake /etc/nixos/#host  # To activate NixOS.
```

I currently have four hosts, all on NixOS:

- `splendor`: (NixOS) My [custom built desktop](https://pcpartpicker.com/user/meowihaveagrape/saved/wKxRK8).
- `haiqin`: (NixOS) My primary laptop, a Thinkpad X1 Carbon 9th Gen.
- `neptune`: (NixOS) My secondary laptop, a Thinkpad X1 Carbon 5th Gen.
- `zen`: (NixOS) An OVH server.

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

`flake.nix` is the entrypoint for the Nix code in `home`, `os`, and `pkgs`; it
exports the Home Manager and NixOS configurations.

# Screenshots

# Philosophy

# Personal Tools

I like to write software for myself. Some more reusable software is spun out
into separate repositories, but other software remains in this repository
within the `pkgs` directory. The more interesting tools and scripts are:

- [Backup Scripts](./pkgs/backup-scripts): Manage my local and remote backups.
- [File Uploader](./pkgs/file-uploader): Upload files to various image and file
  hosting services.
- [EXIF & Last Modified Syncer](./pkgs/exif-mtime-sync/): Sync an image's EXIF
  Created Date and filesystem Last Modified time.

# Networking

All hosts are connected to each other via Tailscale VPN. There is an ACL,
defined [here](./tailscale.policy.hujson).

The ACL is applied via GitOps; see the [GitHub Action](./.github/workflows/tailscale.yml) for the instructions.

# File Synchronization

# Media Management

music books manga images movies tv

# File Navigation

# Backgrounds

# Fonts
