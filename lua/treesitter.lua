-- We also need to set the filetype in .vimrc when reading tuc/tucir files
vim.filetype.add({
  extension = {
    tuc = "tucan",
    tucir = "tucanir",
  }
})

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tucan = {
  install_info = {
    url = "https://github.com/mrnugget/tree-sitter-tucan",
    files = {"src/parser.c"},
    branch = "main",
  },
  filetype = "tucan",
}

parser_config.tucanir = {
  install_info = {
    url = "https://github.com/mrnugget/tree-sitter-tucanir",
    files = {"src/parser.c"},
    branch = "main",
  },
  filetype = "tucanir",
}

-- parser_config.sql = {
--   install_info = {
--     url = "https://github.com/DerekStride/tree-sitter-sql",
--     files = { "src/parser.c" },
--     branch = "main",
--   },
-- }

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
    "markdown_inline",
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
    "yaml",
    "tucan",
    -- "sql",
    "tucanir"
  },
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
  indent = {
    enable = false
  },
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
