#!/bin/sh

set -ex

ln -fs ~/.vim/vimrc ~/.vimrc

mkdir -p ~/.config/nvim
ln -fs ~/.vim/nvim_init.vim ~/.config/nvim/init.vim

mkdir -p ~/.vim/tmp/undo
mkdir -p ~/.vim/tmp/backup
