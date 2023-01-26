local actions = require('telescope.actions') 
require('telescope').setup({
  pickers = {
    live_grep = {
      mappings = {
        i = { ["<c-f>"] = actions.to_fuzzy_refine },
      },
    },
  },
})

-- Find files using Telescope command-line sugar.
vim.keymap.set('n', 'zf', '<cmd>Telescope find_files find_command=rg,--hidden,--ignore,--files,--glob,!.git prompt_prefix=🔍 theme=ivy<cr>')
vim.keymap.set('n', 'zF', '<cmd>Telescope find_files find_command=rg,--hidden,--no-ignore,--files,--glob,!.git,--glob,!node_modules prompt_prefix=🔍 theme=ivy<cr>')
vim.keymap.set('n', 'zg', '<cmd>Telescope live_grep vimgrep_arguments=rg,--hidden,--with-filename,--no-heading,--line-number,--column,--smart-case,--glob,!.git prompt_prefix=🔍 theme=ivy<cr>')
vim.keymap.set('n', 'zb', '<cmd>Telescope buffers theme=ivy<cr>')
vim.keymap.set('n', 'zh', '<cmd>Telescope help_tags theme=ivy<cr>')

