-- UTF-8 encoding
vim.scriptencoding = 'utf-8'

-- Reset augroup
local augroup = vim.api.nvim_create_augroup('MyAutoCmd', { clear = true })

vim.opt.maxmempattern = 2000000

-- Character settings
vim.opt.encoding = 'utf-8'
vim.opt.fileencodings = 'utf-8,iso-2022-jp,euc-jp,cp932,sjis'
vim.opt.fileformats = 'unix,dos,mac'

-- Editor settings
vim.opt.number = true
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true
vim.opt.title = true
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.shortmess:append('c')
vim.opt.ruler = true
vim.opt.showmatch = true
vim.opt.list = true
vim.opt.listchars = { tab = '▸ ', eol = '↲', extends = '❯', precedes = '❮', space = '⋅' }
vim.opt.foldmethod = 'indent'
vim.opt.foldlevel = 100
vim.opt.completeopt = 'menuone,noinsert'
vim.opt.mouse = ''

-- Cursor movement settings
vim.opt.backspace = 'indent,eol,start'
vim.opt.whichwrap = 'b,s,h,l,<,>,[,]'

-- File processing settings
vim.cmd('filetype plugin indent on')
vim.opt.confirm = true
vim.opt.hidden = true
vim.opt.autoread = true
vim.opt.backup = false
vim.opt.swapfile = false

-- Window settings
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Tab indent settings
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true

-- Clipboard settings
vim.opt.clipboard:append("unnamedplus")

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true

---------------------------------------------------------------
-- Keymap settings

-- Set leader to <Space>
vim.g.mapleader = ' '

-- <Space>o to open new file
vim.keymap.set('n', '<Leader>o', ':enew<CR>', { noremap = true })
-- <Space>w to save file
vim.keymap.set('n', '<Leader>w', ':w<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>q', ':q<CR>', { noremap = true })
-- <Space><Space> to switch to visual line mode
vim.keymap.set('n', '<Leader><Leader>', 'V', { noremap = true })

-- Don't yank on x
vim.keymap.set('n', 'x', '"_x', { noremap = true })
vim.keymap.set('n', 'X', '"_X', { noremap = true })

-- Don't yank when pasting in visual mode
vim.keymap.set('x', 'p', 'pgvygv<esc>', { noremap = true })

-- Use jj instead of ESC in INSERT mode
vim.keymap.set('i', 'jj', '<ESC>', { noremap = true, silent = true })

-- Enable very magic by default in search
vim.keymap.set('n', '/', '/\\v', { noremap = true })

-- Replace searched text
vim.keymap.set('n', '#', ':%s///gc<left><left><left>', { noremap = true })

-- Emacs bindings in command mode
vim.keymap.set('c', '<C-a>', '<Home>', { noremap = true })
vim.keymap.set('c', '<C-e>', '<End>', { noremap = true })
vim.keymap.set('c', '<C-b>', '<Left>', { noremap = true })
vim.keymap.set('c', '<C-f>', '<Right>', { noremap = true })
vim.keymap.set('c', '<M-b>', '<S-Left>', { noremap = true })
vim.keymap.set('c', '<M-f>', '<S-Right>', { noremap = true })

-- Buffer navigation
vim.keymap.set('n', '<C-p>', ':bp<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-n>', ':b#<CR>', { noremap = true, silent = true })

-- Quickfix navigation
vim.keymap.set('n', '<C-[>', ':cp<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-]>', ':cn<CR>', { noremap = true, silent = true })

-- Terminal mode settings
vim.keymap.set('n', '<C-t>', ':term<CR>i', { noremap = true, silent = true })
vim.api.nvim_create_user_command('T', function(opts)
  vim.cmd('split | wincmd J | terminal ' .. opts.args)
  vim.cmd('startinsert')
end, { nargs = '*' })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true })
local function send_to_terminal(seq)
  local chan = vim.b.terminal_job_id
  if chan then
    vim.api.nvim_chan_send(chan, seq)
  end
end
vim.keymap.set("t", "<C-]>", function()
  send_to_terminal("\x1b")
end, { noremap = true, silent = true })
vim.keymap.set("t", "<S-Up>", function()
  send_to_terminal("\x1b[<64;40;1M")
end, { noremap = true, silent = true, desc = "Send wheel Up to terminal job"})
vim.keymap.set("t", "<S-Down>", function()
  send_to_terminal("\x1b[<65;40;1M")
end, { noremap = true, silent = true, desc = "Send wheel down to terminal job"})
---------------------------------------------------------------
-- Load configuration files
vim.cmd('runtime local.vim')
vim.cmd('runtime plug.vim')
vim.cmd('runtime tab.vim')
vim.cmd('runtime osc52.vim')
require('toggle_terminal')
require('utility')
require('win_nav')

---------------------------------------------------------------
-- Ripgrep function to send results to quickfix
local function rg(word)
  local cmd = string.format('rg --column --hidden --no-heading --glob "!.git" --glob "!node_modules" --vimgrep "%s" .', word)
  vim.fn.setqflist({}, 'r', { lines = vim.fn.systemlist(cmd) })
  vim.cmd('cwindow')
end

vim.api.nvim_create_user_command('Rg', function(opts)
  rg(opts.args)
end, { nargs = 1 })

vim.cmd('syntax enable')


-- 巨大ファイル対応
vim.api.nvim_create_autocmd("BufReadPre", {
  callback = function(args)
    local max_size = 2 * 1024 * 1024 -- 2MB
    local stat = vim.loop.fs_stat(args.file)
    if stat and stat.size > max_size then
      vim.b.large_file = true
    end
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    if vim.b.large_file then
      vim.opt_local.syntax = "off"
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.undofile = false
      vim.opt_local.swapfile = false
      vim.opt_local.loadplugins = false
    end
  end,
})

