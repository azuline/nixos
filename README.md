# blissful

## Setup

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

#### Broken

Some programs are installed outside of nixpkgs because nixpkgs sucks:

- rofi (starting evolution via nixpkgs rofi created glibc issues)
- evolution (i have a plugin... it is not in nixos)
  - `evolution-on` tray plugin
- evince (persisting document location wasn't working)
- calibre (just got errors firing it up)
- alsa-utils (got some shared library error)
- zoom (video doesn't work and needs some extra QT envvar)
- blueman (can't connect to bluetooth? get exception)
- i3wsr (`cargo install i3wsr`) (not in nixpkgs)
- kube-linter (not in nixpkgs)
- anki (rofi doesn't start it o.O)

#### System-wide

Install these through system package manager instead of nix

- wireguard
- fonts-roboto
- pinentry-gtk2
- xdg-utils
- qt5-style-plugins

#### Other Notes

- (debian) `sudo update-alternatives --install /usr/bin/www-browser www-browser "$HOME/.nix-profile/bin/firefox" 100`

- Use evdev over libinput.
- `/etc/default/keyboard` contains `XKBOPTIONS="altwin:swap_lalt_lwin,caps:escape_shifted_capslock"`
