#!/bin/sh

readonly archive_url="https://github.com/kpachnis/dotfiles/tarball/master"
readonly tmp_dir="$(mktemp -d)"

tar_options="--exclude install.sh --exclude .gitignore --strip-components 1"

if [ "$(uname -s)" = "Linux" ]; then
    tar_options="--exclude Library $tar_options"
fi

if [ -x "$(command -v curl)" ]; then
    fetch_cmd="$(command -v curl) -L"
else
    printf "Can't find curl\n"
    exit 1
fi

$fetch_cmd $archive_url -o $tmp_dir/dotfiles.tar.gz

tar -zxf $tmp_dir/dotfiles.tar.gz $tar_options -C $HOME

rm -fr $tmp_dir

