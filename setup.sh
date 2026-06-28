#!/bin/sh

set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

backup_path() {
  path=$1
  if [ -e "$path" ] || [ -L "$path" ]; then
    mv "$path" "$path.backup.$(date +%Y%m%d%H%M%S)"
  fi
}

link_path() {
  source=$1
  target=$2

  if [ "$source" = "$target" ]; then
    return
  fi

  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    return
  fi

  if [ -L "$target" ]; then
    rm "$target"
  elif [ -e "$target" ]; then
    backup_path "$target"
  fi

  ln -s "$source" "$target"
}

brew_install_if_missing() {
  command_name=$1
  formula=$2

  if command -v "$command_name" >/dev/null 2>&1; then
    return
  fi

  if command -v brew >/dev/null 2>&1; then
    brew install "$formula"
  else
    echo "warning: $command_name not found; install $formula manually" >&2
  fi
}

mkdir -p "$HOME/.config"

link_path "$repo_dir" "$HOME/.vim"
link_path "$repo_dir/vimrc" "$HOME/.vimrc"
link_path "$repo_dir/nvim" "$HOME/.config/nvim"

mkdir -p "$HOME/.vim/tmp/undo"
mkdir -p "$HOME/.vim/tmp/backup"

brew_install_if_missing nvim neovim
brew_install_if_missing rg ripgrep
brew_install_if_missing tree-sitter tree-sitter-cli
brew_install_if_missing typescript-language-server typescript-language-server

if command -v nvim >/dev/null 2>&1; then
  nvim --headless "+lua require('nvim-treesitter').install({ 'bash', 'c', 'go', 'html', 'javascript', 'json', 'lua', 'markdown', 'markdown_inline', 'python', 'query', 'rust', 'toml', 'tsx', 'typescript', 'vim', 'vimdoc', 'yaml' }):wait(300000)" +qa
fi

echo "Installed Vim config: $HOME/.vim -> $repo_dir"
echo "Installed Vim config: $HOME/.vimrc -> $repo_dir/vimrc"
echo "Installed Neovim config: $HOME/.config/nvim -> $repo_dir/nvim"
