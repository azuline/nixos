# On an X11 system, symlink this file to `.xsessionrc` instead.

# Set some environment variables.
export GTK_THEME=Plata-Noir-Compact
export GPG_TTY=$(tty)
export EDITOR=vim
export QT_QPA_PLATFORMTHEME=qt5ct

export PATH="$PATH:/var/lib/flatpak/exports/bin"
export PATH="$HOME/.local/bin:$PATH"

# If running bash, include the .bashrc.
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# Nix
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh";

    export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"
    export LOCALE_ARCHIVE=$(nix-build '<nixpkgs>' -A glibcLocales)/lib/locale/locale-archive
fi

