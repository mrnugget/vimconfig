require("oil").setup {
  view_options = {
    show_hidden = true,
  },
}

-- Need this for :Gbrowse to still work
vim.cmd [[command! -nargs=1 Browse silent execute '!open' shellescape(<q-args>,1)]]
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
