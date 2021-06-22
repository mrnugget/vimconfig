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
  local rhs = string.format("<cmd>lua R('plugins.telescope')['%s']()<CR>", f)
  vim.api.nvim_set_keymap("n", key, rhs, map_options)
end

local helpers = {}

helpers.grep_word_under_cursor = function()
  require('telescope.builtin').grep_string({ search = vim.fn.expand("<cword>") })
end

helpers.grep_string = function()
  require('telescope.builtin').grep_string({ search = vim.fn.input("grep: ")})
end

helpers.edit_dotfiles = function()
  require('telescope.builtin').find_files({
      shorten_path = false,
      cwd = "~/.dotfiles",
      prompt = "~ dotfiles ~",
    })
end

helpers.edit_vimconfig = function()
  require('telescope.builtin').find_files({
      shorten_path = false,
      cwd = "~/.vim",
      prompt = "~ vim ~",
    })
end

helpers.find_files_in_directory_of_buffer = function()
  require('telescope.builtin').find_files({
      cwd = vim.fn.expand("%:p:h"),
    })
end

map_builtin('<leader>fi', 'find_files')
map_builtin('<leader>ff', 'find_files')
map_helper('<leader>fp', 'find_files_in_directory_of_buffer')

map_builtin('<leader>fr', 'oldfiles')

map_builtin('<leader>fb', 'buffers')
map_builtin('<leader>fh', 'help_tags')
map_builtin('<leader>fR', 'lsp_references')
map_builtin('<leader>fS', 'lsp_document_symbols')
map_builtin('<leader>fs', 'lsp_workspace_symbols')
map_builtin('<leader>fl', 'live_grep')
map_builtin('<leader>fo', 'file_browser')

map_helper('<leader>fw', 'grep_word_under_cursor')
map_helper('<leader>fg', 'grep_string')

map_helper('<leader>fd', 'edit_dotfiles')
map_helper('<leader>fv', 'edit_vimconfig')

helpers.project_finder = function()
  require("telescope.builtin").find_files({
      prompt_title = "< ~/work >",
      cwd = "~/work",
    })
end

map_helper('<leader>fP', 'project_finder')

return helpers
