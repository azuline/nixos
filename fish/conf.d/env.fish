set -g GTK_IM_MODULE ibus
set -g XMODIFIERS @im-bus
set -g QT_IM_MODULE ibus

set -g TERM xterm-256color
set -gx QT_QPA_PLATFORMTHEME qt5ct

set -gx GPG_TTY (tty)
set -gx EDITOR nvim

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

# nixos applications
set -g XDG_DATA_DIRS "$HOME/.nix-profile/share:$XDG_DATA_DIRS"

# opam configuration
source /home/blissful/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
