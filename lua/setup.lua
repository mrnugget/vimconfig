require "globals"

-------------------------------------------------------------------------------
-- Telescope
-------------------------------------------------------------------------------
require "plugins.telescope"

-------------------------------------------------------------------------------
-- Mason
-------------------------------------------------------------------------------
require("mason").setup()

-------------------------------------------------------------------------------
-- LSP configuration
-------------------------------------------------------------------------------

require("inlay-hints").setup {
  -- renderer to use
  -- possible options are dynamic, eol, virtline and custom
  -- renderer = "inlay-hints/render/dynamic",
  renderer = "inlay-hints/render/eol",

  hints = {
    parameter = {
      show = true,
      highlight = "whitespace",
    },
    type = {
      show = true,
      highlight = "Whitespace",
    },
  },

  -- Only show inlay hints for the current line
  only_current_line = false,

  eol = {
    -- whether to align to the extreme right or not
    right_align = false,

    -- padding from the right if right_align is true
    right_align_padding = 7,

    parameter = {
      separator = ", ",
      format = function(hints)
        return string.format(" <- (%s)", hints)
      end,
    },

    type = {
      separator = ", ",
      format = function(hints)
        return string.format(" => %s", hints)
      end,
    },
  },
}

R "lsp"
-- lsp-trouble.nvim
require("trouble").setup {
  auto_preview = false,
  auto_close = true,
  action_keys = {
    -- default binding is <esc> for this and it confuses me endlessly that I
    -- can't just escape in that window.
    cancel = {},
  },
}

vim.api.nvim_set_keymap(
  "n",
  "<leader>xx",
  "<cmd>TroubleToggle workspace_diagnostics<cr>",
  { silent = true, noremap = true }
)

require("fidget").setup {}
-------------------------------------------------------------------------------
-- Treesitter
-------------------------------------------------------------------------------

require "treesitter"

-------------------------------------------------------------------------------
-- Markdown helper
-------------------------------------------------------------------------------
require "markdown"

-------------------------------------------------------------------------------
-- cmp configuration
-------------------------------------------------------------------------------
vim.opt["completeopt"] = { "menu", "menuone", "noselect" }

local cmp = require "cmp"
local lspkind = require "lspkind"

cmp.setup {
  formatting = {
    format = lspkind.cmp_format {
      with_text = true,
      menu = {
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        vsnip = "[vsnip]",
        nvim_lua = "[Lua]",
      },
    },
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm { select = true },
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "vsnip" },
    { name = "buffer", keyword_length = 5 },
    { name = "path" },
  },
}
cmp.setup.filetype("markdown", {
  sources = cmp.config.sources {
    { name = "path" }, -- You can specify the `cmp_git` source if you were installed it.
  },
})
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

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
