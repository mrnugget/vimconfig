require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
  indent = {
    enable = true
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
