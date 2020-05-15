#!/bin/sh

set -ex

ln -s ~/.vim/vimrc ~/.vimrc

mkdir -p ~/.config/nvim
ln -s ~/.vim/nvim_init.vim ~/.config/nvim/init.vim

mkdir -p ~/.vim/tmp/undo
mkdir -p ~/.vim/tmp/backup
