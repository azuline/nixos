# dotfiles

## Setup

Most programs and configurations are managed through home-manager.

1. Set up the unstable channels of [nixpkgs](https://nixos.org/download.html)
   and [home-manager](https://github.com/nix-community/home-manager).

Enable flakes

```bash
echo 'experimental-features = nix-command flakes' > ~/.config/nix/nix.conf
```

Then build:

```bash
home-manager switch
```

### System install

Some programs are installed outside of nixpkgs because nixpkgs sucks (jk <3):

- kitty (nixGL is really annoying)
- firefox (nixGL is really annoying)
- rofi (starting evolution via nixpkgs rofi created glibc issues)
- zoom (video doesn't work and needs some extra QT envvar)
- evolution (i have a plugin... it is not in nixos)
  - `evolution-on` tray plugin
- evince (persisting document location wasn't working)
- calibre (just got errors firing it up)
- alsa-utils (got some shared library error)
- blueman (can't connect to bluetooth? get exception)
- anki (rofi doesn't start it o.O)

### System-wide

Install these through system package manager instead of nix

- wireguard
- fonts-roboto
- pinentry-gtk2
- xdg-utils
- qt5-style-plugins

## Other Notes

- Use evdev over libinput.
- `/etc/default/keyboard` contains `XKBOPTIONS="altwin:swap_lalt_lwin,caps:escape_shifted_capslock"`
