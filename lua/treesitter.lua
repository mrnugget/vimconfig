require'nvim-treesitter.configs'.setup {
  ensure_installed = {  -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    "bash",
    "bibtex",
    "c",
    "c_sharp",
    "clojure",
    "cmake",
    "comment",
    "commonlisp",
    "cpp",
    "css",
    "dockerfile",
    "dot",
    "elm",
    "go",
    "gomod",
    "gowork",
    "graphql",
    "hcl",
    "html",
    "http",
    "javascript",
    "jsdoc",
    "jsonc",
    "latex",
    "llvm",
    "lua",
    "make",
    "markdown",
    "ninja",
    "python",
    "regex",
    "rst",
    "ruby",
    "rust",
    "scala",
    "scheme",
    "scss",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "yaml"
  },
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
  -- indent = {
  --   enable = true
  -- },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "vin",
      node_incremental = "vni",
      scope_incremental = "vsi",
      node_decremental = "vnd",
    },
  },

  textobjects = {
    move = {
      enable = true,
    }
  }
}
