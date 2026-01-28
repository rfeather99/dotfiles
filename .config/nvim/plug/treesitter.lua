if vim.fn.empty(vim.fn.globpath(vim.o.rtp, 'autoload/nvim_treesitter.vim')) == 1 then
  return
end

require('nvim-dap-repl-highlights').setup()
require('nvim-treesitter.configs').setup {
  ensure_installed = "all",
  highlight = {
    enable = true,
    disable = function(_, buf)
      return vim.b[buf].large_file
    end,
  },
  indent = {
    enable = false, -- これを設定することでtree-sitterによるインデントを有効にできます
    disable = function(_, buf)
      return vim.b[buf].large_file
    end,
  },
}

-- thorはrubyのシンタックス
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.thor', 'Thorfile' },
  command = 'set filetype=ruby',
})

-- *.pipelineはJenkinsfileなので、groovyのシンタックス
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.pipeline',
  command = 'set filetype=groovy',
})
