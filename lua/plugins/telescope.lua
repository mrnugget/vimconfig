local actions = require('telescope.actions')

require('telescope').setup {
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- even more opts
      },
    }
  },
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
require("telescope").load_extension("ui-select")

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
-- using gi here to copy `fi` above and to use two different fingers
map_builtin('<leader>gi', 'git_status')
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

local action_state = require "telescope.actions.state"
local Path = require "plenary.path"
local os_sep = Path.path.sep

local notes_folder = "~/Dropbox/notes"
local notes_file_ext = ".md"

local find_notes = function(category)
  local prompt_title = "< NOTES: " .. category .. " >"
  local default_text = category .. " - "
  if category == "" then
    prompt_title = "< NOTES >"
    default_text = ""
  end

  require("telescope.builtin").find_files({
    prompt_title = prompt_title,
    cwd = notes_folder,
    default_text = default_text,
    attach_mappings = function(prompt_bufnr, map)
      local is_dir = function(value)
        return value:sub(-1, -1) == os_sep
      end

      local create_new_markdown = function()
        local file = action_state.get_current_line()
        if file == "" then
          return
        end

        local current_picker = action_state.get_current_picker(prompt_bufnr)
        local fpath = current_picker.cwd .. os_sep .. file .. notes_file_ext
        local header = "# " .. file

        if not is_dir(fpath) then
          actions.close(prompt_bufnr)
          Path:new(fpath):touch { parents = true }
          vim.cmd(string.format(":e %s", fpath))

          local buf = vim.api.nvim_get_current_buf()
          vim.api.nvim_buf_set_lines(buf, 0, 0, false, {header})
        else
          print("is directory!")
        end
      end

      map("i", "<C-e>", create_new_markdown)
      map("n", "<C-e>", create_new_markdown)
      return true
    end,
  })
end

helpers.tucan_notes_finder = function() find_notes("Tucan") end
map_helper('<leader>tnn', 'tucan_notes_finder')

helpers.sourcegraph_notes_finder = function() find_notes("Sourcegraph") end
map_helper('<leader>snn', 'sourcegraph_notes_finder')

helpers.notes_finder = function() find_notes("") end
map_helper('<leader>nn', 'notes_finder')


helpers.notes_grep = function()
  require('telescope.builtin').live_grep({
      shorten_path = false,
      cwd = notes_folder,
      prompt = "~ LIVE GREP NOTES ~",
    })
end
map_helper('<leader>gn', 'notes_grep')

return helpers
