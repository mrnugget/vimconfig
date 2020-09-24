#!/bin/sh

set -ex

ln -fs ~/.vim/vimrc ~/.vimrc

mkdir -p ~/.config/nvim
ln -fs ~/.vim/nvim_init.vim ~/.config/nvim/init.vim
ln -fs ~/.vim/coc-settings.json ~/.config/nvim/coc-settings.json

mkdir -p ~/.vim/tmp/undo
mkdir -p ~/.vim/tmp/backup
