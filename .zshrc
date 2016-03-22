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

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export GPG_TTY=$(tty)

[[ -x $(command -v vimpager) ]] &&  export PAGER=vimpager
export LESS=-R
export WORDCHARS=${WORDCHARS//[&.;\/]}

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zhistory

PROMPT='%m:%1~${vcs_info_msg_0_} %# '

fpath+=(~/.zsh/site-functions /usr/local/share/zsh/site-functions)

path=(
    ~/bin
    ~/.local/bin
    ~/.rbenv/bin
    ~/.pyenv/bin
    /usr/local/bin
    /usr/local/sbin
    /bin
    /usr/bin
    /sbin
    /usr/sbin
    /opt/X11/bin
    /usr/local/MacGPG2/bin
)

path=(${(u)^path:A}(N-/))

if [[ -x $(command -v vim) ]]; then
    export EDITOR=$(command -v vim)
    alias vi="$EDITOR"
    alias view="$EDITOR -R"
else
    export EDITOR=vi
fi
export VISUAL=$EDITOR

watch=(notme)

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
compdef '_files -g "*.in"' pip-compile
compdef '_files -g "*.txt"' pip-sync

compdef '_hosts' ansible
compdef '_hosts' dig

compdef gpg2=gpg


autoload -U add-zsh-hook

case $TERM in
    xterm*|rxvt*)
        add-zsh-hook precmd xterm_title
        ;;
esac

autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' actionformats '(%b|%a)'
zstyle ':vcs_info:*' formats '(%b%c%u)'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:*' unstagedstr '-'

if [[ $OSTYPE =~ darwin ]]; then
    alias ls='ls -F'
    alias ldd='otool -L'
fi

if [[ $OSTYPE =~ linux ]]; then
    alias ls='ls -F'

    if [[ -n $DISPLAY ]]; then
        export BROWSER=firefox
        export NO_AT_BRIDGE=1

        alias 2don='xrandr --output DP-1 --auto --right-of LVDS-0'
        alias 2doff='xrandr --output DP-1 --off'
    else
        export BROWSER=w3m
    fi
    export VAGRANT_DEFAULT_PROVIDER=libvirt

    [[ -x $(command -v lesspipe) ]] && eval $(lesspipe)
fi

[[ -x $(command -v rbenv) ]] && eval "$(rbenv init -)"
[[ -x $(command -v pyenv) ]] && eval "$(pyenv init -)"


alias cp='cp -i'
alias enc='openssl aes-256-cbc -salt'
alias dec='openssl aes-256-cbc -d'
alias ctmp='find $TMP -ctime +10 -delete'
alias l='ls -chlt'
alias dot='ls -d .*[[:alnum:]]'
alias du1='du -h -d 1'
alias mv='mv -i'
alias rm='rm -i'
alias timestamp='date +%Y%m%d_%H%M%S'
alias today='date +%Y%m%d'

if [[ -x $(command -v vagrant) ]]; then
    alias vu='vagrant up --provision'
    alias vp='vagrant provision'
    alias vh='vagrant halt'
    alias vs='vagrant ssh'
fi

precmd() { vcs_info }


certfingerprint() {
    openssl s_client -connect "$1" < /dev/null 2>/dev/null \
        | openssl x509 -fingerprint -noout -in /dev/stdin
}

path() {
    foreach dir ($path)
        printf "%s\n" $dir
    end
}

prj() {
    if [[ -z $projects_dirs ]]; then
        printf "$(tput bold)projects_dirs$(tput sgr0) is not set\n"
        return  1
    fi

    if [[ -n "$1"  && "$1" == 'list' ]]; then
        foreach dir ($projects_dirs)
            foreach project ($dir/*(D/))
                [[ -d "$project" ]] && printf "${project##/*/}\n"
            end
        end
    elif [[ -n "$1" ]]; then
        foreach dir ($projects_dirs)
            [[ -d "$dir/$1" ]] && cd "$dir/$1"
        end
    else
        printf "Usage: prj list | <project>\n"
    fi
}

xterm_title() { print -Pn "\e]0;%n@%M\a" }

flush_dns_cache() {
    case $OSTYPE in
        darwin*)
            sudo dscacheutil -flushcache
            sudo killall -HUP mDNSResponder
            ;;
        *)
            printf "Unknown system\n"
            ;;
    esac
}

[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

