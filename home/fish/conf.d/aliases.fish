# Default aliases in fish; erase them so we start from a blank slate.
functions --erase ls
functions --erase ll
functions --erase l

alias ls='ls -h --group-directories-first --color'
alias grep='grep --color=auto'
alias info='info --vi-keys'

if test (uname) = 'Darwin'
  alias xc='pbcopy'
  alias xp='pbpaste'
else
  alias xc='xclip -sel c'
  alias xp='xclip -sel c -o'
end

# Minor conveniences.
abbr --add --global v 'vim'
abbr --add --global n 'nnn'
abbr --add --global hm 'home-manager'

abbr --add --global rscp 'rsync -ah --progress'
abbr --add --global ytv 'yt-dlp --remux-video mkv --embed-subs --embed-chapters'
abbr --add --global ytm 'yt-dlp -x --audio-format opus'

# Substitutions.
abbr --add --global s 'perl -pe'
abbr --add --global si 'perl -i -pe'
# Set these as aliases too for use in xargs.
alias s='perl -pe'
alias si='perl -i -pe'
alias xargs='xargs '

# Systemd
abbr --add --global sc 'sudo systemctl'
abbr --add --global scu 'systemctl --user'

# Kubectl
abbr --add --global k "kubectl"
abbr --add --global kg "kubectl get"
abbr --add --global kgd "kubectl get -o wide deployments"
abbr --add --global kgp "kubectl get -o wide pods"
abbr --add --global kl "kubectl logs"
abbr --add --global kc "kubectl config"
abbr --add --global kcg "kubectl config get-contexts"
abbr --add --global kcu "kubectl config use-context"
abbr --add --global kcc "kubectl config current-context"
abbr --add --global kcuc "kubectl config unset current-context"

# Git
abbr --add --global gname 'git config user.name; git config user.email'
abbr --add --global gst 'git status'
abbr --add --global gd 'git diff'
abbr --add --global gds 'git diff --staged'
abbr --add --global gdl 'git -c core.pager=less diff'
abbr --add --global gp 'git push'
abbr --add --global gl 'git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
abbr --add --global gr 'cd (git rev-parse --show-toplevel)'
abbr --add --global gb 'git branch'
abbr --add --global gbl "git branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative))' --sort=-committerdate"
abbr --add --global ga 'git add'
abbr --add --global gc 'git commit'
abbr --add --global gco 'git checkout'
abbr --add --global gcom 'git checkout master'
abbr --add --global gcl 'git clean'
abbr --add --global gcp 'git cherry-pick'
abbr --add --global gpl 'git pull'
abbr --add --global gplr 'git pull --rebase'
abbr --add --global grs 'git reset'
abbr --add --global gre 'git rebase'
abbr --add --global grea 'git rebase --abort'
abbr --add --global grec 'git rebase --continue'
abbr --add --global gres 'git restore --staged'
abbr --add --global gm 'git merge'
abbr --add --global gma 'git merge --abort'
abbr --add --global gmc 'git diff --name-only --diff-filter=U'
abbr --add --global gsync 'git reset --hard master'

function speedrun
    git add "$(git rev-parse --show-toplevel)"
    git commit -m "$argv[1]"
    git push
    set pr_out (gh prc -l bypass --title "$argv[1]" --body "")
    echo "$pr_out"
    echo "$pr_out" | rg -o "\d+" | xargs gh prm
    gh prw
end

function gprune
    echo "> prune remote"
    git fetch --prune
    echo "> prune local branches"
    git for-each-ref --format "%(refname:short) %(upstream:track)" \
       | awk '$2 == "[gone]" {print $1}' \
       | xargs -r git branch -D
end

# nnn
alias nsel="cat ~/.config/nnn/.selection"

# Tmux
abbr --add --global tn 'tmux new -s'
abbr --add --global ta 'tmux attach -t'
abbr --add --global tl 'tmux ls'

# Image Uploading
alias lastscrot='command ls -d1t ~/images/Screenshots/* | head -n1'
alias ups='up (lastscrot)'

# beets
abbr --add --global trc '~/scripts/transcoder/run.sh'
abbr --add --global bm 'beet modify --album'
abbr --add --global ba 'beet ls --album | sort'
abbr --add --global bart '~/scripts/beets-scripts/artist-transform.py'
abbr --add --global bgen '~/scripts/beets-scripts/genre-inferrer.py'
function bac
    beet modify artist::"$argv[1]" artist="$argv[2]"
    beet modify -a albumartist::"$argv[1]" albumartist="$argv[2]"
end
function bal
    beet modify -a album::"$argv[1]" album="$argv[2]"
end

# Specify output dir and pass `-s <url>` or `-q <query>`.
abbr --add --global lnd 'lncrawl --all --single --force --suppress --output /tmp/webnovel/'

function tea
    termdown $argv[1] && spd-say "tea done yay yay"
end
