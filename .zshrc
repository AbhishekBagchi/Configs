export PATH=/home/abhishek/Android/SDK/android-sdk-linux/platform-tools/adb:$PATH
export EDITOR='vim'
export ANDROID_HOME=/home/abhishek/Android/SDK/android-sdk-linux
export ANDROID_NDK_ROOT=/home/abhishek/Android/android-ndk-r11c

# Lines configured by zsh-newuser-install
HISTCONTROL=ignoreboth
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory extendedglob nomatch
unsetopt autocd
#bindkey -v
# End of lines configured by zsh-newuser-install

bindkey "^R" history-incremental-search-backward

# little hack to get rid of useless gvim warning messages
alias gvim="gvim 2>/dev/null"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/zsh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'
fi

source ~/.shell_aliases

# Vim mode
bindkey -v
export KEYTIMEOUT=1
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
PROMPT='[%F{cyan}%n:%M%f: %F{yellow}%~%f :%F{red}$(parse_git_branch_and_add_brackets)%f]
%# '
