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

PROMPT='%n@%m:%3~ ${vcs_info_msg_0_}%(!.#.>) '

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

compdef '_hosts' ansible
compdef '_hosts' dig
compdef '_hosts' fping

compdef gpg2=gpg


if [[ -x $(command -v git) ]]; then
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' actionformats '(%b|%a%) '
    zstyle ':vcs_info:*' formats '(%b%c%u) '
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '+'
    zstyle ':vcs_info:*' unstagedstr '-'

    precmd() { vcs_info }
fi

autoload -U add-zsh-hook
[[ $TERM =~ xterm* ]] && add-zsh-hook precmd xterm_title

if [[ $OSTYPE =~ darwin ]]; then
    alias ls='ls -G'
    alias ldd='otool -L'
fi

if [[ $OSTYPE =~ linux ]]; then
    alias ls='ls --color=auto'

    if [[ -n $DISPLAY ]]; then
        export BROWSER=firefox
        export NO_AT_BRIDGE=1

        alias 2don='xrandr --output DP-1 --auto --right-of LVDS-0'
        alias 2doff='xrandr --output DP-1 --off'
    else
        export BROWSER=w3m
    fi

    [[ -x $(command -v vagrant) ]] && export VAGRANT_DEFAULT_PROVIDER=libvirt

    [[ -x $(command -v lesspipe) ]] && eval $(lesspipe)
fi

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

bindkey -e

[[ -f ~/.vim/bundle/gruvbox/gruvbox_256palette.sh ]] && source ~/.vim/bundle/gruvbox/gruvbox_256palette.sh

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

xterm_title() { print -Pn "\e]0; %n: %~\a" }

tt() { printf '\e]1;%s\a' $1 }

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

rfc() {
    open "https://tools.ietf.org/html/rfc$1"
}

[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

