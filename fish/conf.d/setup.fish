set -g GTK_IM_MODULE ibus
set -g XMODIFIERS @im-bus
set -g QT_IM_MODULE ibus
ibus-daemon -drx

set -g TERM xterm-256color
set -gx QT_QPA_PLATFORMTHEME qt5ct

set -gx GPG_TTY (tty)
set -gx EDITOR vim

# Prepend /usr/local/bin so everything there registers first. This lets us
# override other binaries with custom scripts.
set -g PATH "$HOME/.local/bin:$PATH"

set -g npm_config_prefix "$HOME/.node_modules"
set -g GEM_HOME "$HOME/.gems"
set -g TEXMFHOME "$HOME/.texmf"

set -g PATH "$PATH:$HOME/.poetry/bin"
set -g PATH "$PATH:$HOME/.node_modules/bin"
set -g PATH "$PATH:$HOME/.cargo/bin"
set -g PATH "$PATH:$HOME/.gems/bin"
set -g PATH "$PATH:$HOME/.cabal/bin"
set -g PATH "$PATH:$HOME/.gem/ruby/2.7.0/bin"
set -g PATH "$PATH:$HOME/.yarn/bin"
set -g PATH "$PATH:$HOME/.config/yarn/global/node_modules/.bin"
set -g PATH "$PATH:$HOME/.git-fuzzy/bin"
set -g PATH "$PATH:/var/lib/flatpak/exports/bin"

[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"

# Git fuzzy
set -x PATH "$HOME/.git-fuzzy/bin:$PATH"

# pyenv
set -gx PYENV_ROOT "$HOME/.pyenv"
set -gx PATH "$PATH:$PYENV_ROOT/bin"
if command -v pyenv 1>/dev/null 2>&1
  pyenv init - | source
end

# goenv configuration.
set -g GOENV_ROOT "$HOME/.goenv"
set -g PATH "$GOENV_ROOT/bin:$PATH"
source (goenv init - | psub)
set -g GOENV_GOPATH_PREFIX "$HOME/.go"
set -g GOPATH "$HOME/.go"
set -g PATH "$GOROOT/bin:$PATH"
set -g PATH "$PATH:$GOPATH/bin"

# nixos applications
set -g XDG_DATA_DIRS "$HOME/.nix-profile/share:$XDG_DATA_DIRS"
