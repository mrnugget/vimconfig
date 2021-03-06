local actions = require('telescope.actions')

require('telescope').setup {
  defaults = {
    file_sorter = require('telescope.sorters').get_fzy_sorter,

    file_previewer   = require('telescope.previewers').vim_buffer_cat.new,
    grep_previewer   = require('telescope.previewers').vim_buffer_vimgrep.new,
    qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
    mappings = {
      i = {
        -- Also close on Esc in insert mode
        ["<esc>"] = actions.close,
        ["<C-[>"] = actions.close,
        ["<C-q>"] = actions.send_to_qflist,
      },
    },
  },
}

require('telescope').load_extension('fzy_native')

local map_options = { noremap = true, silent = true, }

local map_builtin = function(key, f)
  local rhs = string.format("<cmd>lua require('telescope.builtin')['%s']()<CR>", f)
  vim.api.nvim_set_keymap("n", key, rhs, map_options)
end

local map_helper = function(key, f)
  local rhs = string.format("<cmd>lua require('plugins.telescope')['%s']()<CR>", f)
  vim.api.nvim_set_keymap("n", key, rhs, map_options)
end

local helpers = {}

helpers.grep_word_under_cursor = function()
  require('telescope.builtin').grep_string({ search = vim.fn.expand("<cword>") })
end

helpers.grep_string = function()
  require('telescope.builtin').grep_string({ search = vim.fn.input("grep: ")})
end

map_builtin('<leader>fi', 'find_files')
map_builtin('<leader>ff', 'find_files')
map_builtin('<leader>fb', 'buffers')
map_builtin('<leader>fh', 'help_tags')
map_builtin('<leader>fR', 'lsp_references')
map_builtin('<leader>fS', 'lsp_document_symbols')
map_builtin('<leader>fs', 'lsp_workspace_symbols')
map_builtin('<leader>fl', 'live_grep')

map_helper('<leader>fw', 'grep_word_under_cursor')
map_helper('<leader>fg', 'grep_string')

return helpers
