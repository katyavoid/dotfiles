#!/bin/sh

readonly tar_cmd="$(command -v bsdtar || command -v tar)"
readonly archive_url="https://github.com/kpachnis/dotfiles/tarball/master"
readonly tmp_dir="$(mktemp -d)"

tar_options="--exclude install.sh --exclude .gitignore --strip-components 1"

if [ ! "$(uname -s)" = "Darwin" ]; then
    tar_options="--exclude Library $tar_options"
fi

if [ -x "$(command -v curl)" ]; then
    fetch_cmd="$(command -v curl) -L"
else
    printf "Can't find curl\n"
    exit 1
fi

$fetch_cmd $archive_url -o $tmp_dir/dotfiles.tar.gz

$tar_cmd -zxf $tmp_dir/dotfiles.tar.gz $tar_options -C $HOME

if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
	if [ -x $(command -v git) ]; then
		git clone -q https://github.com/VundleVim/Vundle.vim.git \
			"$HOME/.vim/bundle/Vundle.vim"
	fi
fi

rm -fr $tmp_dir

