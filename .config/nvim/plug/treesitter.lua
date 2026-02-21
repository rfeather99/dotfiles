require('nvim-dap-repl-highlights').setup()
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("vim-treesitter-start", {}),
  pattern = "*",
  callback = function(ctx)
    if vim.b[ctx.buf].large_file then
      return
    end
    -- parser が無い等のエラーは握りつぶすのが推奨パターン
    pcall(vim.treesitter.start, ctx.buf)
  end,
})

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

-- CoffeeScript
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.coffee',
  command = 'set filetype=coffee',
})
