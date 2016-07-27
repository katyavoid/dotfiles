# vim: fdm=marker

# Options {{{

setopt no_global_rcs
setopt auto_cd
setopt auto_list
setopt pushd_ignore_dups
setopt complete_aliases
setopt hash_list_all
setopt extended_glob
setopt hist_ignore_dups
setopt clobber
setopt correct
setopt prompt_subst
setopt no_beep
setopt auto_pushd
setopt pushd_minus
setopt pushd_silent
setopt pushd_to_home

# }}}

# Environment {{{ 

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export WORDCHARS=${WORDCHARS//[&.;\/]}

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zhistory

DIRSTACKSIZE=10

fpath+=(~/.zsh/site-functions /usr/local/share/zsh/site-functions)
fpath=(${(u)^fpath:A}(N-/))

path=(~/bin ~/.local/bin /usr/local/bin /usr/local/sbin /usr/local/games /Library/TeX/texbin /bin /usr/bin /sbin /usr/sbin /usr/games /usr/X11R6/bin /opt/X11/bin /usr/local/MacGPG2/bin)
path=(${(u)^path:A}(N-/))

if [[ -x $(command -v vim) ]]; then
    export EDITOR=vim
else
    export EDITOR=vi
fi
export VISUAL=$EDITOR

export GPG_TTY=$(tty)
export PAGER=$(command -v vimpager || command -v less)
export LESS=-RX

# }}}

# Prompt {{{

PROMPT='%~${vcs_info_msg_0_}%(!.#.>) '

# }}}

# Completion {{{

zstyle ':completion::*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh
zstyle ':completion::complete:*' rehash true
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*:*:kill:*:processes' '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER"

autoload -U compinit
compinit

compdef '_files -g "*.(asciidoc|md|mkd|markdown)"' pandoc
compdef '_files -g "*.yml"' ansible-playbook

compdef '_hosts' ansible
compdef '_hosts' dig
compdef '_hosts' fping

compdef gpg2=gpg

# }}}

# VCS {{{

if [[ -x $(command -v git) ]]; then
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' actionformats ' (%b|%a%) '
    zstyle ':vcs_info:*' formats ' (%b%c%u) '
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '+'
    zstyle ':vcs_info:*' unstagedstr '-'

    precmd() { vcs_info }
fi

# }}}

# Hooks {{{

autoload -U add-zsh-hook
[[ $TERM =~ xterm* ]] && add-zsh-hook precmd xterm_title

# }}}

# Aliases {{{

if [[ $OSTYPE =~ darwin ]]; then
    alias ls='ls -G'
    alias ldd='otool -L'
    alias ss='open /System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app'
fi

if [[ $OSTYPE =~ linux ]]; then
    alias ls='ls --color=auto'

    if [[ -n $DISPLAY ]]; then
        alias 2don='xrandr --output DP-1 --auto --right-of LVDS-0'
        alias 2doff='xrandr --output DP-1 --off'
    fi
fi

if [[ $OSTYPE =~ bsd ]]; then
    alias ls='ls -F'
fi

[[ $EDITOR == vim ]] && alias vi='vim'

alias cp='cp -i'
alias enc='openssl aes-256-cbc -salt'
alias dec='openssl aes-256-cbc -d'
alias ctmp='find $TMP -ctime +10 -delete'
alias l='ls -chlt'
alias dot='ls -d .*(/,.)'
alias du1='du -h -d 1'
alias mv='mv -i'
alias reload='source ~/.zshrc'
alias rm='rm -i'
alias timestamp='date +%Y%m%d_%H%M%S'
alias today='date +%Y%m%d'

if [[ -x $(command -v vagrant) ]]; then
    alias vu='vagrant up --provision'
    alias vp='vagrant provision'
    alias vh='vagrant halt'
    alias vs='vagrant ssh'
fi

# }}}

# Functions {{{

xterm_title() { print -Pn "\e]0; %M\a" }

# }}}

# Misc {{{

watch=(notme)
bindkey -e

# }}}

[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

