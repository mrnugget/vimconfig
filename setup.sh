#!/bin/sh

set -ex

# Create config directory for Neovim
mkdir -p ~/.config/nvim

# Link the Lua configuration
ln -fs ~/.vim/init.lua ~/.config/nvim/init.lua

# Create necessary directories for undo and backup
mkdir -p ~/.vim/tmp/undo
mkdir -p ~/.vim/tmp/backup
