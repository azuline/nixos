My configuration files.

## Setup

Symlink the desired dotfiles to the appropriate locations.

### Fish

Install the [fisher](https://github.com/jorgebucaran/fisher) plugin manager and
install the listed plugins. Not sure of the exact process right now.

### Nixpkgs

Some programs and configurations are managed through home-manager. Set up the
unstable channels of [nixpkgs](https://nixos.org/download.html) and
[home-manager](https://github.com/nix-community/home-manager). Then build:

```bash
home-manager switch
```

Add the stable channel with:

```bash
nix-channel --add https://nixos.org/channels/nixos-20.09 stable
```

#### OpenGL

If not on NixOS, install the wrappers in: https://github.com/guibou/nixGL.

#### Broken

Some programs are installed outside of nixpkgs because nixpkgs sucks:

- rofi (starting evolution via nixpkgs rofi created glibc issues)
- evolution (i have a plugin... it is not in nixos)
  - `evolution-on` tray plugin
- calibre (just got errors firing it up)
- alsa-utils (got some shared library error)
- zoom (video doesn't work and needs some extra QT envvar)
- blueman (can't connect to bluetooth? get exception)
- foliate (not in nixpkgs)
  - can install via flatpak, but need to enable filesystem access for cli to work properly
  - `sudo flatpak override com.github.johnfactotum.Foliate --filesystem=host`

#### Other Notes

- the nixos picom service runs slow as hell, so we start it outside of nixos...

## Computers

### Splendor

- OS: debian
- WM: i3
- Shell: fish

#### Changes

- Use evdev over libinput.
- `/etc/default/keyboard` contains `XKBOPTIONS="altwin:swap_lalt_lwin,caps:escape_shifted_capslock"`

### Tranquility

- OS: debian
- DE: sway
- Shell: fish
