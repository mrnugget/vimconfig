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
