# /etc/nixos

This repository contains my system configs. I use [Nix](https://nixos.org/) to manage my systems, with NixOS whenever possible, and Home Manager otherwise.

I use [Nix Flakes](https://nixos.wiki/wiki/Flakes). All NixOS and Home Manager configurations are specified as outputs in the `flake.nix` file.

The system configurations can be activated with the following commands:

```bash
$ home-manager switch --flake /etc/nixos/#host        # To activate Home Manager.
$ sudo nixos-rebuild switch --flake /etc/nixos/#host  # To activate NixOS.
```

I currently have three hosts:

- `splendor`: (NixOS) My [custom built desktop](https://pcpartpicker.com/user/meowihaveagrape/saved/wKxRK8).
- `haiqin`: (NixOS) My primary laptop, a Thinkpad X1 Carbon 9th Gen.
- `neptune`: (NixOS) My secondary laptop, a Thinkpad X1 Carbon 5th Gen.

## Notes on Content

This repository is organized into the following directories:

- `home` contains bundles of configurations for Home Manager. Each host selects the bundles that apply to it.
- `os` contains NixOS configurations for each host on NixOS. 
- `pkgs` contains an overlaid `nixpkgs` that's shared between all configs. My patches to `nixpkgs` are applied here, and my custom software is stored here.
- `services` contains some of general Nomad & Consul specs that are not tied to another project of mine.

`flake.nix` is the entrypoint for the Nix code in `home`, `os`, and `pkgs`; it exports the Home Manager and NixOS configurations.

Some of the little tools I wrote for my workflow are kept in this repository's `pkgs` directory instead of spun out into their own repositories. They are:

- [Backup Scripts](./pkgs/backup-scripts): Manage my local and remote backups.
- [File Uploader](./pkgs/file-uploader): Upload files to various image and file hosting services.
- [EXIF & Last Modified Syncer](./pkgs/exif-mtime-sync/): Sync an image's EXIF Created Date and filesystem Last Modified time.

All hosts are connected to each other via Tailscale VPN. There is an ACL, defined [here](./tailscale.policy.json).

The ACL is applied via GitOps; see the [GitHub Action](./.github/workflows/tailscale.yml) for the instructions.

Machines synchronize files and application state with each other using Syncthing.

I maintain a directory of desktop backgrounds in `~/backgrounds`, which I periodically cycle through. Backgrounds are configured using `xwallpaper`.

I maintain a separate repository of fonts for system usage and design projects in `~/fonts`. This repository is symlinked to `~/.local/share/fonts/collection`.

## Bootstrapping

The following commands bootstrap a new laptop. These should be run after booting into a minimal NixOS installation media.

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

The following commands bootstrap an OVH server. These should be run after booting into a minimal NixOS installation media.

```bash
# Partition the drives into boot and primary.
$ parted /dev/nvme0n1 -- mklabel gpt
$ parted /dev/nvme1n1 -- mklabel gpt
$ parted --script --align optimal /dev/nvme0n1 -- mklabel gpt mkpart 'BIOS-boot0' 1MB 2MB set 1 bios_grub on mkpart 'boot0' 2MB 2000MB mkpart 'primary0' 2001MB '100%'
$ parted --script --align optimal /dev/nvme1n1 -- mklabel gpt mkpart 'BIOS-boot0' 1MB 2MB set 1 bios_grub on mkpart 'boot1' 2MB 2000MB mkpart 'primary1' 2001MB '100%'
# Create RAID partitions for boot and primary.
$ mdadm --zero-superblock /dev/nvme0n1p1
$ mdadm --zero-superblock /dev/nvme0n1p2
$ mdadm --zero-superblock /dev/nvme1n1p1
$ mdadm --zero-superblock /dev/nvme1n1p2
$ mdadm --create --run --verbose /dev/md/boot --level=1 --raid-devices=2 --homehost=$HOST --name=boot /dev/nvme0n1p2 /dev/nvme1n1p2 --metadata=0.90
$ mdadm --create --run --verbose /dev/md/root --level=1 --raid-devices=2 --homehost=$HOST --name=root /dev/nvme0n1p3 /dev/nvme1n1p3
# Wipe filesystem signatures that might be on the RAID from some possibly
# existing older use of the disks (RAID creation does not do that).
# See https://serverfault.com/questions/911370/why-does-mdadm-zero-superblock-preserve-file-system-information
$ wipefs -a /dev/md/boot
$ wipefs -a /dev/md/root
# Disable RAID recovery. We don't want this to slow down machine provisioning
# in the rescue mode. It can run in normal operation after reboot.
$ echo 0 > /proc/sys/dev/raid/speed_limit_max
# Encrypt the primary partition with LUKS.
$ cryptsetup --batch-mode luksFormat /dev/md/root
# Configure LVM.
$ cryptsetup luksOpen /dev/md/root enc-pv
$ pvcreate /dev/mapper/enc-pv
$ vgcreate vg /dev/mapper/enc-pv
$ lvcreate --extents 95%FREE -n root vg
# Format partitions.
$ mkfs.fat -F 32 -n boot /dev/md/boot
$ mkfs.ext4 -F -L root /dev/mapper/vg-root
# Mount disks into /mnt for NixOS installer.
$ mount /dev/disk/by-label/root /mnt
$ mkdir /mnt/boot
$ mount /dev/disk/by-label/boot /mnt/boot
# Generate NixOS config. Modify boot parameters to match the configuration.nix
# in this repository.
$ nixos-generate-config --root /mnt
# Install NixOS.
$ nixos-install --root /mnt --max-jobs 40
# And we're done!
$ reboot
```

## Nomad & Consul

- global management keys
- acls
- node access tokens
- consul intentions
