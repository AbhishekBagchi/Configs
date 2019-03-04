export EDITOR='vim'

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000000
SAVEHIST=10000000
setopt appendhistory extendedglob nomatch
unsetopt autocd
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall

zstyle :compinstall filename '/home/abhbag01/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

bindkey "^R" history-incremental-search-backward

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'
fi

source .shell_aliases

alias ls='ls --color=auto'
alias ll='ls -alh'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias vi='vim'
alias viR='vim -R'
alias wget='wget -c'
alias gopen='xdg-open'
alias tmux='tmux -2'
# little hack to get rid of useless gvim warning messages
alias gvim="gvim 2>/dev/null"

# User specific aliases and functions
setopt PROMPT_SUBST
function parse_git_branch_and_add_brackets {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \[\1\]/'
}

PROMPT='[%F{red}%n@%M%f:%F{yellow}%~%f:%F{green}$(parse_git_branch_and_add_brackets)%f]
%# '

alias food='curl http://menu'
alias euhpc='ssh -X login1.euhpc.arm.com'

# Vim mode
bindkey -v
export KEYTIMEOUT=1
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd v edit-command-line
# Use vim cli mode
bindkey '^P' up-history
bindkey '^N' down-history
# backspace and ^h working even after
# returning from command mode
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
# ctrl-w removed word backwards
bindkey '^w' backward-kill-word

function countdown(){
    while true; do echo -ne "`date +%H:%M:%S:%N`\r"; done
}
