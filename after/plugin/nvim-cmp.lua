vim.opt["completeopt"] = { "menu", "menuone", "noselect" }

require("luasnip.loaders.from_vscode").lazy_load()

local cmp = require "cmp"
local lspkind = require "lspkind"
local luasnip = require "luasnip"

cmp.setup {
  sources = {
    { name = "nvim_lsp", keyword_length = 3 },
    { name = "cody" },
    { name = "luasnip", keyword_length = 3 },
    { name = "buffer", keyword_length = 5 },
    { name = "path", keyword_length = 3 },
  },
  formatting = {
    format = lspkind.cmp_format {
      with_text = true,
      menu = {
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[Lua]",
        cody = "[Cody]",
      },
    },
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ["<c-a>"] = cmp.mapping.complete {
      config = {
        sources = {
          { name = "cody" },
        },
      },
    },
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-e>"] = cmp.mapping.close(),
    -- ["<CR>"] = cmp.mapping.confirm { select = true },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
  },
}

cmp.setup.filetype("markdown", {
  sources = cmp.config.sources {
    { name = "path" }, -- You can specify the `cmp_git` source if you were installed it.
  },
})
