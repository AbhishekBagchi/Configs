# Cache `arch=$(arch)` once for use throughout the file
if [[ "$OSTYPE" == "darwin"* ]]; then
    arch=$(arch)
fi

# Plugins are submodules under ~/.zsh/plugins/. Source them directly.
# zsh-defer must load synchronously (other plugins use it for deferring).
source ~/.zsh/plugins/romkatv/zsh-defer/zsh-defer.plugin.zsh

# fpath setup: must happen before compinit so all completions are registered.
fpath=(~/.zsh/plugins/zsh-users/zsh-completions/src $fpath)
fpath+=(~/.zsh/plugins/taskwarrior ~/.zfunc)

# compinit runs synchronously: many plugins call compdef which requires it.
# With the cached compdump (< 24h), compinit -C is fast (~5ms).
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qNmh-24) ]]; then
    compinit -C
else
    compinit
fi

# OMZ plugins (compdef is now available)
source ~/.zsh/plugins/git/git.plugin.zsh
source ~/.zsh/plugins/taskwarrior/taskwarrior.plugin.zsh
source ~/.zsh/plugins/command-not-found/command-not-found.plugin.zsh

# Defer the rest (autosuggestions and fzf-tab can wait until after first prompt).
zsh-defer source ~/.zsh/plugins/zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh
zsh-defer source ~/.zsh/plugins/Aloxaf/fzf-tab/fzf-tab.plugin.zsh

# Cache output of `eval "$(slow-cmd)"` style commands so subsequent shells skip the subshell.
# Usage: zsh_eval_cache <name> <command...>
# First run: builds cache after first prompt (deferred). Subsequent runs: instant source.
zsh_eval_cache() {
    local name=$1 ; shift
    local cache=${ZSH_CACHE_DIR:-$HOME/.cache/zsh}/$name.zsh
    if [[ -s $cache ]]; then
        source $cache
        return
    fi
    [[ -d ${cache:h} ]] || mkdir -p ${cache:h}
    zsh-defer -c "$* > $cache && source $cache"
}

export EDITOR='vim'

HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt sharehistory appendhistory extendedglob nomatch menucomplete
unsetopt autocd

# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'
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

GIT_PROMPT_EXECUTABLE="haskell" 
source ~/.zsh/git-prompt.zsh/git-prompt.zsh
get_git_branch() {
    git rev-parse --abbrev-ref HEAD
}

parse_git_branch_and_add_brackets() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \[\1\]/'
}
ZSH_GIT_PROMPT_SHOW_UPSTREAM='full'
ZSH_GIT_PROMPT_SHOW_STASH=1
PROMPT='[%F{red}%n@%m%f: %F{yellow}%~%f :%F{green}$(gitprompt)  %f]
%# '

bindkey "^R" history-incremental-pattern-search-backward

# Sort files by modification date
zstyle ':completion:*' file-sort modification

# Include hidden files
#_comp_options+=(globdots)


# Setup the correct homebrew if macos
# This is here because it's needed later in the file, so .shell_aliases would be too late
if  [[ "$OSTYPE" == "darwin"* ]]; then
    if [[ "$arch" == "arm64" ]]; then
        alias brew=/opt/homebrew/bin/brew
    else
        alias brew=/usr/local/bin/brew
    fi
fi

# Random functions
countdown() {
    while true; do echo -ne "`date +%H:%M:%S:%N`\r"; done
}

install() {
    if  [[ "$OSTYPE" == "darwin"* ]]; then
        brew install $1
    else
        sudo apt install $1
    fi
}

package-search() {
    if  [[ "$OSTYPE" == "darwin"* ]]; then
        brew search $1
    else
        apt-cache search $1
    fi
}

# Find header and matching source file for a C++ basename (e.g., foo.)
_cpp_pair() {
    local base=$1
    REPLY_FILES=()
    local ext
    for ext in h hpp hh; do
        [[ -f "${base}${ext}" ]] && { REPLY_FILES+="${base}${ext}"; break; }
    done
    for ext in cpp cc; do
        [[ -f "${base}${ext}" ]] && { REPLY_FILES+="${base}${ext}"; break; }
    done
}

vicpp()    { _cpp_pair "$1"; vim    "${REPLY_FILES[@]}"; }
vivsplit() { _cpp_pair "$1"; vim -O "${REPLY_FILES[@]}"; }

vimdiff_sorted() {
    vimdiff <(sort ${1}) <(sort ${2})
}

diff_sorted() {
    diff <(sort ${1}) <(sort ${2})
}

# Example -> sleep 120 &; wait_for_pid_and_run $(get_pid sleep) echo "Sleep done"
get_pid() {
    pgrep -f "$1" | head -n1
}

wait_for_pid_and_run() {
    pid=${1}
    shift
    cmd="$@"
    echo "PID is $pid"
    echo "Command is $cmd"
    if  [[ "$OSTYPE" == "darwin"* ]]; then
        lsof -p $pid +r 1 &>/dev/null && eval $cmd
    else
        tail --pid=$pid -f /dev/null && eval $cmd
    fi
}

_dated() {
    # _dated <p|a> <name> <format>  →  prefix or append a date to a name
    local pos=$1 name=$2 fmt=$3
    local d="$(date +"$fmt")"
    [[ $pos == p ]] && echo "${d}_${name}" || echo "${name}_${d}"
}
prepend_date()          { _dated p "$1" '%F'; }
append_date()           { _dated a "$1" '%F'; }
append_date_mmddyy()    { _dated a "$1" '%m%d%Y'; }
prepend_date_and_time() { _dated p "$1" '%F_%H_%M'; }
append_date_and_time()  { _dated a "$1" '%F_%H_%M'; }

path_append() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}

path_prepend() {
    # Always prepend
    PATH="$1${PATH:+":$PATH"}"
}

update_font_size() {
    # Check if integer
    if [[ "$1" =~ ^-?[0-9]+$ ]] ; then
        # Check if MacOS
        # FIXME Check if wezterm or alacritty
        if  [[ "$OSTYPE" == "darwin"* ]]; then
            sed -E -i '' "s/(size = )(.*)/\1${1}/g" ~/.config/alacritty/alacritty.toml
            sed -E -i '' "s/(config.font_size = )(.*)/\1${1}/g" ~/.wezterm.lua
        else
            sed -i "s/\(size = \)\(.*\)/\1${1}/g" ~/.config/alacritty/alacritty.toml
            sed -i "s/\(config.font_size = \)\(.*\)/\1${1}/g" ~/.wezterm.lua
        fi
    fi
}

get_font_size() {
    grep 'size = ' ~/.config/alacritty/alacritty.toml
    grep 'config.font_size = ' ~/.wezterm.lua
}

alias weekly_task='task end.after:today-1wk completed'

if  [[ "$OSTYPE" == "darwin"* ]]; then
    if [[ "$arch" == "arm64" ]]; then
        # Cached coreutils path - doesn't change often
        coreutils_path="/opt/homebrew/opt/coreutils/libexec/gnubin"
        if [ -d "$coreutils_path" ]; then
            path_prepend $coreutils_path
        fi
    fi
fi

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
if whence dircolors >/dev/null; then
  eval "$(dircolors -b)"
  alias ls='ls --color'
else
  export CLICOLOR=1
fi
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

if [[ -a ~/.shell_aliases ]]; then
    source ~/.shell_aliases
fi

if [[ -a ~/.zshrc.extra ]]; then
    source ~/.zshrc.extra
fi

#Setup fzf
export FZF_DEFAULT_OPTS="--height 40% --tmux bottom,40% --layout reverse --border top \
--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
--color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# Defer fzf integration; bind ALT-C only on macOS (see fzf issue #164)
zsh-defer -c 'source <(fzf --zsh); [[ "$OSTYPE" == "darwin"* ]] && bindkey "ç" fzf-cd-widget'

if [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH=/opt/homebrew/bin:$PATH
    path_prepend /opt/homebrew/opt/ccache/libexec
    # Cached python path
    path_prepend /opt/homebrew/opt/python/libexec/bin
fi
path_append ~/.cargo/bin


# Lazy-loaded Python REPL enhancements
if [[ -f ~/.config/python/pythonstartup.py ]]; then
    export PYTHONSTARTUP=~/.config/python/pythonstartup.py
fi

eval "$(/opt/homebrew/bin/zsh-patina activate)"
zsh-defer -c 'eval "$(zoxide init zsh)"'

DISABLE_AUTO_TITLE="true" # Disable auto-setting terminal title.
COMPLETION_WAITING_DOTS="true" # Display red dots whilst waiting for completion.
setopt HIST_IGNORE_ALL_DUPS

# Auto-compile zsh scripts to bytecode (.zwc) for faster sourcing on next start.
# Runs after first prompt; the compiled file is used on subsequent shell starts.
zsh-defer -c '
    local f
    for f in ~/.zshrc ~/.shell_aliases ~/.zsh/git-prompt.zsh/git-prompt.zsh; do
        [[ -f $f && (! -f $f.zwc || $f -nt $f.zwc) ]] && zcompile -- $f
    done
    [[ -f ~/.zcompdump && ! -f ~/.zcompdump.zwc ]] && zcompile ~/.zcompdump
    [[ -f ~/.zcompdump-$HOST-$ZSH_VERSION && ! -f ~/.zcompdump-$HOST-$ZSH_VERSION.zwc ]] && zcompile ~/.zcompdump-$HOST-$ZSH_VERSION
'
