#!/usr/bin/sh

set -ex

git clone git://github.com/mrnugget/vimconfig.git ~/.vim

ln -s ~/.vim/vimrc ~/.vimrc

mkdir -p ~/.config/nvim
ln -s ~/.vim/nvim_init.vim ~/.config/nvim/init.vim

mkdir -p ~/.vim/tmp/undo
mkdir -p ~/.vim/tmp/backup
