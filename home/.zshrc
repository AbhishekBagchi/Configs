# Antigen
if  [[ "$OSTYPE" == "darwin"* ]]; then
    arch=$(arch)
    if [[ "$arch" == "arm64" ]]; then
        source /opt/homebrew/opt/antigen/share/antigen/antigen.zsh
    else
        echo "This antigen setup needs verification, and should be deprecated"
        source /usr/local/bin/brew/opt/antigen/share/antigen/antigen.zsh
    fi
else
    source ~/antigen.zsh
fi
antigen use oh-my-zsh
antigen bundle git
antigen bundle taskwarrior
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

bindkey "^R" history-incremental-pattern-search-backward

# Autocomplete colours
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==34=34}:${(s.:.)LS_COLORS}")'

# Setup the correct homebrew if macos
# This is here because it's needed later in the file, so .shell_aliases would be too late
if  [[ "$OSTYPE" == "darwin"* ]]; then
    arch=$(arch)
    if [[ "$arch" == "arm64" ]]; then
        alias brew=/opt/homebrew/bin/brew
    else
        alias brew=/usr/local/bin/brew
    fi
fi

# Random functions
function countdown(){
    while true; do echo -ne "`date +%H:%M:%S:%N`\r"; done
}

function install(){
    if  [[ "$OSTYPE" == "darwin"* ]]; then
        brew install $1
    else
        sudo apt install $1
    fi
}

function package-search(){
    if  [[ "$OSTYPE" == "darwin"* ]]; then
        brew search $1
    else
        apt-cache search $1
    fi
}

function vicpp {
    header_ext=
    if [ -f ${1}h ]; then
        header_ext=h
    elif [ -f ${1}hpp ]; then
        header_ext=hpp
    elif [ -f ${1}hh ]; then
        header_ext=hh
    fi
    source_ext=
    if [ -f ${1}cpp ]; then
        source_ext=cpp
    elif [ -f ${1}cc ]; then
        source_ext=cc
    fi
    vim $1{${header_ext},${source_ext}}
}

function vivsplit {
    header_ext=
    if [ -f ${1}h ]; then
        header_ext=h
    elif [ -f ${1}hpp ]; then
        header_ext=hpp
    elif [ -f ${1}hh ]; then
        header_ext=hh
    fi
    source_ext=
    if [ -f ${1}cpp ]; then
        source_ext=cpp
    elif [ -f ${1}cc ]; then
        source_ext=cc
    fi
    vim -O $1{${header_ext},${source_ext}}
}

path_append() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}

path_prepend() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$1${PATH:+":$PATH"}"
    fi
}

update_font_size() {
    if [[ "$1" =~ ^-?[0-9]+$ ]] ; then
        if  [[ "$OSTYPE" == "darwin"* ]]; then
            sed -E -i '' "s/(size: )(.*)/\1${1}/g" ~/.config/alacritty/alacritty.yml
        else
            sed -i '' "s/(size: )(.*)/\1${1}/g" ~/.config/alacritty/alacritty.yml
        fi
    fi
}

get_font_size() {
    grep 'size: ' ~/.config/alacritty/alacritty.yml
}

alias weekly_task='task end.after:today-1wk completed'

cursor_mode() {
    # See https://ttssh2.osdn.jp/manual/4/en/usage/tips/vim.html for cursor shapes
    cursor_block='\e[1 q'
    cursor_beam='\e[5 q'

    function zle-keymap-select {
        if [[ ${KEYMAP} == vicmd ]] ||
            [[ $1 = 'block' ]]; then
            echo -ne $cursor_block
        elif [[ ${KEYMAP} == main ]] ||
            [[ ${KEYMAP} == viins ]] ||
            [[ ${KEYMAP} = '' ]] ||
            [[ $1 = 'beam' ]]; then
            echo -ne $cursor_beam
        fi
    }

    zle-line-init() {
        echo -ne $cursor_beam
    }

    zle -N zle-keymap-select
    zle -N zle-line-init
}

cursor_mode

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
if whence dircolors >/dev/null; then
  eval "$(dircolors -b)"
  zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
  alias ls='ls --color'
else
  export CLICOLOR=1
  zstyle ':completion:*:default' list-colors ''
fi
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

if [[ -a ~/.shell_aliases ]] then
    source ~/.shell_aliases
fi

if [[ -a ~/.zshrc.extra ]] then
    source ~/.zshrc.extra
fi
