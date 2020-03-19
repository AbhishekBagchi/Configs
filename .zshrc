# Antigen
source ~/antigen.zsh
antigen use oh-my-zsh
antigen bundle git
antigen bundle zsh-users/zsh-completions
antigen bundle command-not-found
antigen bundle zsh-users/zsh-syntax-highlighting

antigen apply

export EDITOR='vim'

HISTFILE=~/.histfile
HISTSIZE=10000000
SAVEHIST=10000000
setopt sharehistory appendhistory extendedglob nomatch
unsetopt autocd

# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

bindkey "^R" history-incremental-pattern-search-backward

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
fi

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

# User specific aliases and functions
setopt PROMPT_SUBST
function parse_git_branch_and_add_brackets {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \[\1\]/'
}
PROMPT='[%F{red}%n@%M%f:%F{yellow}%~%f:%F{green}$(parse_git_branch_and_add_brackets)%f]
%# '

# Random functions
function countdown(){
    while true; do echo -ne "`date +%H:%M:%S:%N`\r"; done
}

function vicpp {
    vi $1.{h,cpp}
}

function vivsplit {
    vim -O $1.{cpp,h}
}

if [[ -a ~/.shell_aliases ]] then
    source ~/.shell_aliases
fi

if [[ -a ~/.zshrc.extra ]] then
    source ~/.zshrc.extra
fi
