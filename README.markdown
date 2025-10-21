# Thorsten Ball's Neovim Configuration (Lua-only)

This is a Lua-only Neovim configuration using [lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager.

## Installation

```bash
git clone git://github.com/mrnugget/vimconfig.git ~/.vim
cd ~/.vim && ./setup.sh
```

## Plugin Management

This configuration uses [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management.

The first time you start Neovim, lazy.nvim will automatically install itself and all configured plugins.

## Requirements

- Neovim >= 0.9.0
- Git
- Optional: ripgrep (for better grep support)
- Optional: fd (for faster file finding)

## Structure

- `init.lua` - Main configuration file
- `lua/mrnugget/` - Custom Lua modules
  - `globals/init.lua` - Global helper functions
  - `telescope.lua` - Telescope configuration
  - `lsp.lua` - LSP configuration
  - `lsp/helpers.lua` - LSP helper functions
  - `markdown.lua` - Markdown utilities
- `after/plugin/` - Plugin-specific configurations loaded after plugins
- `queries/` - Tree-sitter query files

## Key Features

- Full LSP support for Go, Rust, TypeScript, Python, Lua, C, Zig
- Telescope for fuzzy finding
- Tree-sitter for syntax highlighting
- Git integration with fugitive
- Terminal integration with neoterm
- Custom note-taking system with Telescope
