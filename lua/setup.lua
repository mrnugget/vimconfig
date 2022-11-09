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

-------------------------------------------------------------------------------
-- Leap
-------------------------------------------------------------------------------
require("leap").set_default_keymaps()
