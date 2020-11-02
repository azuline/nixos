case $- in
    *i*) ;;
      *) return;;
esac

shopt -s checkwinsize
shopt -s no_empty_cmd_completion
shopt -s histappend
shopt -s globstar

HISTCONTROL=ignoreboth
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
HISTSIZE=10000
HISTFILESIZE=20000

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export GPG_TTY=$(tty)
export EDITOR=vim
export PS1="\[\e[96m\]\u\[\e[m\]@\[\e[96m\]\h\[\e[m\] \[\e[93m\]\w\[\e[m\] \[\e[92m\]\`parse_git_branch\`\[\e[m\]"

alias ls='ls --color=auto --group-directories-first'
alias l='ls -l'
alias la='ls -la'

alias grep='grep --color=auto'

alias info='info --vi-keys'  # Emacs and cheese not allowed.

alias gname='git config user.name; git config user.email'
alias gupd='git add .; git commit -m update'

alias gitlines='git ls-files | xargs -d "\n" wc -l'
alias gst='git status'
alias gb='git branch'
alias gl='git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
alias gr='cd "$(git rev-parse --show-toplevel)"'

alias rscp='rsync -ah --progress'

alias iscrot='bubblegum upload "$(/bin/ls -d1t ~/images/scrots/* | head -n1 | tr -d \"\\n\")"'
alias iu='bubblegum upload'

[ -f /opt/.fzf.bash ] && source /opt/.fzf.bash

parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}${STAT}] "
	else
		echo ""
	fi
}

parse_git_dirty() {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}
