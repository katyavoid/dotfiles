export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export GPG_TTY=$(tty)
export LESS=-RX
export WORDCHARS=${WORDCHARS//[&.;\/]}

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zhistory

fpath+=(~/.zsh/site-functions /usr/local/share/zsh/site-functions)
fpath=(${(u)^fpath:A}(N-/))

path=(~/bin /usr/local/bin /usr/local/sbin /usr/local/games /Library/TeX/texbin /bin /usr/bin /sbin /usr/sbin /usr/games /opt/X11/bin /usr/local/MacGPG2/bin)
path=(${(u)^path:A}(N-/))

if [[ -x $(command -v vim) ]]; then
    export EDITOR=vim
else
    export EDITOR=vi
fi
export VISUAL=$EDITOR


[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local
