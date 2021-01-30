alias vim='nvim'

alias ls='ls --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias info='info --vi-keys'  # Emacs and cheese not allowed.
alias gname='git config user.name; git config user.email'

alias gupd='git add .; git commit -m update'
alias gitlines='git ls-files | xargs -d "\n" wc -l'
alias gst='git status'
alias gd='git diff'
alias gds='git diff --staged'
alias gp='git push'
alias gpo='git push -u origin HEAD'
alias gl='git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
alias gr='cd (git rev-parse --show-toplevel)'
alias gb="git branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate"
alias gfb='git fuzzy branch'
alias gcm='git commit -m'
alias ga='git add'
alias gc='git checkout'
alias gl='git pull'

alias rscp='rsync -ah --progress'

alias w='cd ~/notes; vim index.md'

alias is='bubblegum upload (/bin/ls -d1t ~/images/scrots/* | head -n1)'
alias iu='bubblegum upload'
alias ims='bubblegum upload --host=imgur.com (/bin/ls -d1t ~/images/scrots/* | head -n1)'
alias imu='bubblegum upload --host=imgur.com'

alias tn='tmux new -s'
alias ta='tmux attach -t'

alias zc='zotcli'

alias grt="grep -v 'no test'"
