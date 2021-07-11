set -g GTK_IM_MODULE ibus
set -g XMODIFIERS @im-bus
set -g QT_IM_MODULE ibus

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

# fzf
export FZF_DEFAULT_COMMAND='fd --type file --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Git fuzzy
set -x PATH "$HOME/.git-fuzzy/bin:$PATH"

# pyenv
status is-interactive; and pyenv init --path | source

# goenv configuration.
set -g GOENV_ROOT "$HOME/.goenv"
set -g PATH "$GOENV_ROOT/bin:$PATH"
# This is slow as balls, just going to copy paste the useful snippet
# source (goenv init - | psub)
if not contains $GOENV_ROOT/shims $PATH
  set -gx PATH $GOENV_ROOT/shims $PATH
end

set -g GOENV_GOPATH_PREFIX "$HOME/.go"
set -g GOPATH "$HOME/.go"
set -g PATH "$GOROOT/bin:$PATH"
set -g PATH "$PATH:$GOPATH/bin"

# nixos applications
set -g XDG_DATA_DIRS "$HOME/.nix-profile/share:$XDG_DATA_DIRS"
