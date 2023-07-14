local actions = require('telescope.actions')
require('telescope').setup({
  pickers = {
    live_grep = {
      mappings = {
        i = { ["<c-f>"] = actions.to_fuzzy_refine },
      },
    },
    buffers = {
      ignore_current_buffer = true,
      sort_lastused = true
    }
  },
})
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')
require('telescope').load_extension('aerial')

-- Find files using Telescope command-line sugar.
vim.keymap.set('n', 'zf', '<cmd>Telescope find_files find_command=rg,--hidden,--ignore,--files,--glob,!.git prompt_prefix=🔍 theme=ivy<cr>')
vim.keymap.set('n', 'zF', '<cmd>Telescope find_files find_command=rg,--hidden,--no-ignore,--files,--glob,!.git,--glob,!node_modules prompt_prefix=🔍 theme=ivy<cr>')
vim.keymap.set('n', 'zg', '<cmd>Telescope live_grep vimgrep_arguments=rg,--hidden,--with-filename,--no-heading,--line-number,--column,--smart-case,--glob,!.git prompt_prefix=🔍 theme=ivy<cr>')
vim.keymap.set('n', 'zb', '<cmd>Telescope buffers theme=ivy<cr>')
vim.keymap.set('n', 'zh', '<cmd>Telescope help_tags theme=ivy<cr>')
vim.keymap.set('n', 'zm', '<cmd>Telescope oldfiles theme=ivy<cr>')
vim.keymap.set('n', 'zs', '<cmd>Telescope colorscheme theme=ivy<cr>')
vim.keymap.set('n', 'zj', '<cmd>Telescope lsp_document_symbols theme=ivy<cr>')
vim.keymap.set('n', 'za', '<cmd>Telescope aerial theme=ivy<cr>')
