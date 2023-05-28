-- We also need to set the filetype in .vimrc when reading tuc/tucir files
vim.filetype.add {
  extension = {
    tuc = "tucan",
    tucir = "tucanir",
  },
}

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.tucan = {
  install_info = {
    url = "https://github.com/mrnugget/tree-sitter-tucan",
    files = { "src/parser.c" },
    branch = "main",
  },
  filetype = "tucan",
}

parser_config.tucanir = {
  install_info = {
    url = "https://github.com/mrnugget/tree-sitter-tucanir",
    files = {
      "src/parser.c",
    },
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

-- From: https://github.com/Wansmer/treesj/discussions/19
require("treesj").setup {
  use_default_keymaps = false,
}

local langs = require("treesj.langs")["presets"]

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "*",
  callback = function()
    local opts = { buffer = true }
    if langs[vim.bo.filetype] then
      vim.keymap.set("n", "gS", "<Cmd>TSJSplit<CR>", opts)
      vim.keymap.set("n", "gJ", "<Cmd>TSJJoin<CR>", opts)
    else
      vim.keymap.set("n", "gS", "<Cmd>SplitjoinSplit<CR>", opts)
      vim.keymap.set("n", "gJ", "<Cmd>SplitjoinJoin<CR>", opts)
    end
  end,
})

require("nvim-treesitter.configs").setup {
  ensure_installed = { -- one of "all", "maintained" (parsers with maintainers), or a list of languages
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
    "tucanir",
    "zig",
  },
  highlight = {
    enable = true, -- false will disable the whole extension
  },
  indent = {
    enable = false,
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
    },
  },
}

----------------------
-- Fixing nvim-treesitter highlighting
-----------------
-- See this comment: https://github.com/nvim-treesitter/nvim-treesitter/commit/42ab95d5e11f247c6f0c8f5181b02e816caa4a4f#commitcomment-87014462
-- Short version: that commit removed old TS* highlight groups that were necessary for some colorschemes.
-- The code below restores them.
local hl = function(group, opts)
  opts.default = true
  vim.api.nvim_set_hl(0, group, opts)
end

-- Misc {{{
hl("@comment", { link = "Comment" })
-- hl('@error', {link = 'Error'})
hl("@none", { bg = "NONE", fg = "NONE" })
hl("@preproc", { link = "PreProc" })
hl("@define", { link = "Define" })
hl("@operator", { link = "Operator" })
-- }}}

-- Punctuation {{{
hl("@punctuation.delimiter", { link = "Delimiter" })
hl("@punctuation.bracket", { link = "Delimiter" })
hl("@punctuation.special", { link = "Delimiter" })
-- }}}

-- Literals {{{
hl("@string", { link = "String" })
hl("@string.regex", { link = "String" })
hl("@string.escape", { link = "SpecialChar" })
hl("@string.special", { link = "SpecialChar" })

hl("@character", { link = "Character" })
hl("@character.special", { link = "SpecialChar" })

hl("@boolean", { link = "Boolean" })
hl("@number", { link = "Number" })
hl("@float", { link = "Float" })
-- }}}

-- Functions {{{
hl("@function", { link = "Function" })
hl("@function.call", { link = "Function" })
hl("@function.builtin", { link = "Special" })
hl("@function.macro", { link = "Macro" })

hl("@method", { link = "Function" })
hl("@method.call", { link = "Function" })

hl("@constructor", { link = "Special" })
hl("@parameter", { link = "Identifier" })
-- }}}

-- Keywords {{{
hl("@keyword", { link = "Keyword" })
hl("@keyword.function", { link = "Keyword" })
hl("@keyword.operator", { link = "Keyword" })
hl("@keyword.return", { link = "Keyword" })

hl("@conditional", { link = "Conditional" })
hl("@repeat", { link = "Repeat" })
hl("@debug", { link = "Debug" })
hl("@label", { link = "Label" })
hl("@include", { link = "Include" })
hl("@exception", { link = "Exception" })
-- }}}

-- Types {{{
hl("@type", { link = "Type" })
hl("@type.builtin", { link = "Type" })
hl("@type.qualifier", { link = "Type" })
hl("@type.definition", { link = "Typedef" })

hl("@storageclass", { link = "StorageClass" })
hl("@attribute", { link = "PreProc" })
hl("@field", { link = "Identifier" })
hl("@property", { link = "Identifier" })
-- }}}

-- Identifiers {{{
hl("@variable", { link = "Normal" })
hl("@variable.builtin", { link = "Special" })

hl("@constant", { link = "Constant" })
hl("@constant.builtin", { link = "Special" })
hl("@constant.macro", { link = "Define" })

hl("@namespace", { link = "Include" })
hl("@symbol", { link = "Identifier" })
-- }}}

-- Text {{{
hl("@text", { link = "Normal" })
hl("@text.strong", { bold = true })
hl("@text.emphasis", { italic = true })
hl("@text.underline", { underline = true })
hl("@text.strike", { strikethrough = true })
hl("@text.title", { link = "Title" })
hl("@text.literal", { link = "String" })
hl("@text.uri", { link = "Underlined" })
hl("@text.math", { link = "Special" })
hl("@text.environment", { link = "Macro" })
hl("@text.environment.name", { link = "Type" })
hl("@text.reference", { link = "Constant" })

hl("@text.todo", { link = "Todo" })
hl("@text.note", { link = "SpecialComment" })
hl("@text.warning", { link = "WarningMsg" })
hl("@text.danger", { link = "ErrorMsg" })
-- }}}

-- Tags {{{
hl("@tag", { link = "Tag" })
hl("@tag.attribute", { link = "Identifier" })
hl("@tag.delimiter", { link = "Delimiter" })
-- }}}
