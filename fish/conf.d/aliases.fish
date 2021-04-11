alias vi='nvim'
alias vim='nvim'
alias vimdiff='nvim -d'

alias ls='ls --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias info='info --vi-keys'

# Safety
alias rm='trash'

alias rscp='rsync -ah --progress'
alias w='cd ~/notes; vim index.md'
alias zc='zotcli'

alias hm='home-manager'

# Kubectl
alias kg="kubectl get"
alias kgd="kg deployments"
alias kgdw="kgd -o wide"
alias kgp="kg pods"
alias kgpw="kgp -o wide"
alias kc="kubectl config"
alias kcg="kc get-contexts"
alias kcu="kc use-context"

# Git
alias gname='git config user.name; git config user.email'
alias gst='git status'
alias gd='git diff'
alias gds='git diff --staged'
alias gp='git push'
alias gpo='git push -u origin HEAD'
alias gl='git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
alias gr='cd (git rev-parse --show-toplevel)'
alias gb="git branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate"
alias gfb='git fuzzy branch'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gpl='git pull'
alias gre='git rebase'
alias gm='git merge'

function gprune
    echo "> prune remote"
    git fetch --prune
    echo "> prune local branches"
    git for-each-ref --format "%(refname:short) %(upstream:track)" \
       | awk '$2 == "[gone]" {print $1}' \
       | xargs -r git branch -D
end

# Tmux
alias tn='tmux new -s'
alias ta='tmux attach -t'
alias tl='tmux ls'

# Image Uploading
alias lastscrot='/bin/ls -d1t ~/images/scrots/* | head -n1'
alias is='bubblegum upload (lastscrot)'
alias iu='bubblegum upload'
alias ims='bubblegum upload --host=imgur.com (lastscrot)'
alias imu='bubblegum upload --host=imgur.com'

# gotestsum
alias gs='gotestsum -- -count=1 -race ./...'
alias gsr='gs -run'
