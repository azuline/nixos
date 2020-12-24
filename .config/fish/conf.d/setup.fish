set GTK_IM_MODULE ibus
set XMODIFIERS @im-bus
set QT_IM_MODULE ibus
ibus-daemon -drx

# opam configuration
# test -r /home/azul/.opam/opam-init/init.sh && . /home/azul/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

set npm_config_prefix $HOME/.node_modules
set GEM_HOME $HOME/.gems
set TEXMFHOME $HOME/.texmf
source $HOME/.cargo/env

set PATH "$PATH:$HOME/.poetry/bin"
set PATH "$PATH:$HOME/.local/bin"
set PATH "$PATH:$HOME/.node_modules/bin"
set PATH "$PATH:$HOME/.cargo/bin"
set PATH "$PATH:$HOME/.gems/bin"
set PATH "$PATH:$HOME/.pyenv/bin"
set PATH "$PATH:$HOME/.cabal/bin"
set PATH "$PATH:$HOME/.gem/ruby/2.7.0/bin"
set PATH "$PATH:$HOME/.yarn/bin"
set PATH "$PATH:$HOME/.config/yarn/global/node_modules/.bin"
set PATH "$PATH:$HOME/.git-fuzzy/bin"

[ -f "/home/azul/.ghcup/env" ] && source "/home/azul/.ghcup/env" # ghcup-env

# . $HOME/.nix-profile/etc/profile.d/nix.sh
