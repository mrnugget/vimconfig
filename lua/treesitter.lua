vim.filetype.add({
  extension = {
    tuc = "tucan",
  }
})

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tucan = {
  install_info = {
    url = "https://github.com/mrnugget/tree-sitter-tucan", -- local path or git repo
    files = {"src/parser.c"},
    -- optional entries:
    branch = "main",
  },
  filetype = "tucan", -- if filetype does not match the parser name
}

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
