# Thorsten Ball's Vim/Neovim Configuration

```bash
git clone git@github.com:mrnugget/vimconfig.git ~/.vimconfig
~/.vimconfig/setup.sh
```

That command links:

- `~/.vim` → `~/.vimconfig`
- `~/.vimrc` → `~/.vimconfig/vimrc`
- `~/.config/nvim` → `~/.vimconfig/nvim`

It also installs missing Homebrew dependencies when `brew` is available:

- `neovim`
- `ripgrep`
- `tree-sitter-cli`
- `typescript-language-server`

Then it starts Neovim headlessly once so built-in `vim.pack` installs plugins
and Treesitter parsers.

The Neovim config lives in `nvim/init.lua` and uses Neovim's built-in package
manager plus `nvim/nvim-pack-lock.json` for reproducible plugin revisions.

The old Vim config is still available as `vimrc` and uses
[vim-plug](https://github.com/junegunn/vim-plug). If you use Vim, open it and
run `:PlugInstall` after setup.
