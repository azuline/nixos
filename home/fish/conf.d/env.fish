set -gx TERM xterm-256color
set -gx GPG_TTY (tty)

# Prepend /usr/local/bin so everything there registers first. This lets us
# override other binaries with custom scripts.
set -gx PATH "$HOME/.local/bin" $PATH

# Fedora doesn't add this to $PATH by default.
set -gx PATH "$PATH:/usr/sbin"

set -g npm_config_prefix "$HOME/.node_modules"
set -g GEM_HOME "$HOME/.gems"
set -g TEXMFHOME "$HOME/.texmf"

set -gx PATH $PATH "$HOME/.poetry/bin"
set -gx PATH $PATH "$HOME/.node_modules/bin"
set -gx PATH $PATH "$HOME/.cargo/bin"
set -gx PATH $PATH "$HOME/.gems/bin"
set -gx PATH $PATH "$HOME/.cabal/bin"
set -gx PATH $PATH "$HOME/.gem/ruby/2.7.0/bin"
set -gx PATH $PATH "$HOME/.yarn/bin"
set -gx PATH $PATH "$HOME/.config/yarn/global/node_modules/.bin"
set -gx PATH $PATH "$HOME/.git-fuzzy/bin"
set -gx PATH $PATH "/var/lib/flatpak/exports/bin"

# fzf
export FZF_DEFAULT_COMMAND="$HOME/.nix-profile/bin/fd --type file --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_G_COMMAND="$FZF_DEFAULT_COMMAND --exclude .pdf"
export FZF_CTRL_C_COMMAND="$HOME/.nix-profile/bin/fd --type directory --hidden --follow --exclude .git"

# for vim chadtree colors stuff
set -gx LS_COLORS 'di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
