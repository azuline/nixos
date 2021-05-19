alias vi='nvim'
alias vim='nvim'
alias vimdiff='nvim -d'

alias ls='exa'
alias grep='grep --color=auto'
alias info='info --vi-keys'

# Safety
alias rm='trash'

# Bug
alias hasura="NODE_OPTIONS= "(which hasura)

abbr --add --global rscp 'rsync -ah --progress'
alias w='cd ~/notes; vim index.md'
abbr --add --global zc 'zotcli'

abbr --add --global hm 'home-manager'

# Kubectl
abbr --add --global kg "kubectl get"
abbr --add --global kgd "kubectl get deployments"
abbr --add --global kgdw "kubectl get deployment -o wide"
abbr --add --global kgp "kubectl get pods"
abbr --add --global kgpw "kubectl get pods -o wide"
abbr --add --global kc "kubectl config"
abbr --add --global kcg "kubectl config get-contexts"
abbr --add --global kcu "kubectl config use-context"

# Git
abbr --add --global gname 'git config user.name; git config user.email'
abbr --add --global gst 'git status'
abbr --add --global gd 'git diff'
abbr --add --global gdl 'git -c core.pager=less diff'
abbr --add --global gds 'git diff --staged'
abbr --add --global gp 'git push'
abbr --add --global gpo 'git push -u origin HEAD'
abbr --add --global gl 'git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
abbr --add --global gr 'cd (git rev-parse --show-toplevel)'
abbr --add --global gb 'git branch'
abbr --add --global gbl "git branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate"
abbr --add --global gfb 'git fuzzy branch'
abbr --add --global ga 'git add'
abbr --add --global gc 'git commit'
abbr --add --global gco 'git checkout'
abbr --add --global gcl 'git clean'
abbr --add --global gpl 'git pull'
abbr --add --global gre 'git rebase'
abbr --add --global grea 'git rebase --abort'
abbr --add --global grec 'git rebase --continue'
abbr --add --global grs 'git restore --staged'
abbr --add --global gm 'git merge'

function gprune
    echo "> prune remote"
    git fetch --prune
    echo "> prune local branches"
    git for-each-ref --format "%(refname:short) %(upstream:track)" \
       | awk '$2 == "[gone]" {print $1}' \
       | xargs -r git branch -D
end

# Tmux
abbr --add --global tn 'tmux new -s'
abbr --add --global ta 'tmux attach -t'
abbr --add --global tl 'tmux ls'

# Image Uploading
alias lastscrot='/bin/ls -d1t ~/images/scrots/* | head -n1'
alias is='bubblegum upload (lastscrot)'
alias iu='bubblegum upload'
alias ims='bubblegum upload --host=imgur.com (lastscrot)'
alias imu='bubblegum upload --host=imgur.com'

# gotestsum
abbr --add --global gs 'gotestsum -- -count=1 -race ./...'
abbr --add --global gsr 'gotestsum -- -count=1 -race ./... -run'
