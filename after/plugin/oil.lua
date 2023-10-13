require("oil").setup()

-- Need this for :Gbrowse to still work
vim.cmd [[command! -nargs=1 Browse silent execute '!open' shellescape(<q-args>,1)]]
