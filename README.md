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

# Bootstrapping

The following commands bootstrap a new machine. These should be run after
booting into a minimal NixOS installation media.

```bash
# Partition the drive into boot and primary.
$ DISK=/dev/nvme0n1  # Set to SSD device name.
$ parted "$DISK" -- mklabel gpt
$ parted "$DISK" -- mkpart ESP fat32 1MiB 512MiB
$ parted "$DISK" -- set 1 boot on
$ parted "$DISK" -- mkpart primary 512MiB 100%
$ BOOT=/dev/nvme0n1p1     # Set boot and primary.
$ PRIMARY=/dev/nvme0n1p2  # Get partition names from `lsblk`.
# Encrypt the primary partition with LUKS.
$ cryptsetup luksFormat "$PRIMARY"
$ cryptsetup luksOpen "$PRIMARY" enc
# Configure LVM with root+swap partitions.
$ pvcreate /dev/mapper/enc
$ vgcreate vg /dev/mapper/enc
$ lvcreate -L 16G -n swap vg
$ lvcreate -l '100%FREE' -n root vg
# Format boot, root, and swap partitions.
$ mkfs.fat -F 32 -n boot "$BOOT"
$ mkfs.ext4 -L root /dev/vg/root
$ mkswap -L swap /dev/vg/swap
# Mount disks into /mnt (for NixOS installer).
$ mount /dev/vg/root /mnt
$ mkdir /mnt/boot
$ mount "$BOOT" /mnt/boot
$ swapon /dev/vg/swap
# Generate NixOS config. Add the following lines to /etc/nixos/configuration.nix:
#
#   boot.initrd.luks.devices.root = {
#     device = "/dev/nvme0n1p2";  # Set this to "$PRIMARY".
#     preLVM = true;
#   }
#   nix.settings.experimental-features = [ "nix-command" "flakes" ];
#   nix.settings.max-jobs = 8;
#   environment.systemPackages = with pkgs; [ git vim ];
#
# These lines configure boot for LUKS+LVM and prepare the system to build this
# repository's configs.
$ nixos-generate-config --root /mnt
# Connect to the internet. Skip this step # if on ethernet. Get `$iface` from
# the `ip l` command.
$ wpa_supplicant -B -i $iface -c <(wpa_passphrase SSID passphrase)
# Install NixOS and then nixos-enter into the new installation.
$ nixos-install
$ reboot
# Download this repository and switch, but keep the generated
# hardware-configuration.nix file. This step assumes that a NixOS flake has
# been pre-prepared for this host.
$ mv /etc/nixos /etc/nixos.backup
$ git clone https://github.com/azuline/nixos /etc/nixos
$ mv /etc/nixos.backup/hardware-configuration.nix /etc/nixos/os/host/
$ nixos-rebuild switch --flake /etc/nixos/#host
# And we're done!
$ reboot
```

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
defined [here](./tailscale.policy.json).

The ACL is applied via GitOps; see the [GitHub Action](./.github/workflows/tailscale.yml) for the instructions.

# File Synchronization

# Media Management

music books manga images movies tv

# File Navigation

# Backgrounds

# Fonts
