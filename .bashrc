case $- in
    *i*) ;;
      *) return;;
esac

HISTCONTROL=ignoreboth
shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s checkwinsize
shopt -s globstar

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

source $HOME/.bash_functions
source $HOME/.shared_aliases
source $HOME/.aliases

export EDITOR=vim
export PATH=$PATH:$HOME/.poetry/bin:$HOME/.local/bin:$HOME/.node_modules/bin:$HOME/.cargo/bin
export PS1="\[\e[96m\]\u\[\e[m\]@\[\e[96m\]\h\[\e[m\] \[\e[93m\]\w\[\e[m\] \[\e[92m\]\`parse_git_branch\`\[\e[m\] "
export npm_config_prefix=~/.node_modules

source $HOME/.bash_override
