-- <C-h/j/k/l> でウィンドウ移動 (normal / terminal モード)
--   h/l: 行き先のウィンドウがない場合、prev/next のタブがあればタブ移動
--        l で次のタブもない場合は tabnew して移動
--   j/k: 行き先のウィンドウがない場合、bottom/top のウィンドウに移動
--   移動先が terminal バッファーなら terminal-job モードに入る
local M = {}

local function enter_terminal_job_mode()
  if vim.bo.buftype == 'terminal' then
    vim.cmd('startinsert')
  end
end

function M.move(dir)
  local prev_win = vim.api.nvim_get_current_win()
  vim.cmd.wincmd(dir)

  if vim.api.nvim_get_current_win() == prev_win then
    if dir == 'h' then
      if vim.fn.tabpagenr() > 1 then
        vim.cmd('tabprevious')
      end
    elseif dir == 'l' then
      if vim.fn.tabpagenr() < vim.fn.tabpagenr('$') then
        vim.cmd('tabnext')
      else
        vim.cmd('tabnew')
      end
    elseif dir == 'j' then
      vim.cmd.wincmd('b')
    elseif dir == 'k' then
      vim.cmd.wincmd('t')
    end
  end

  enter_terminal_job_mode()
end

for _, dir in ipairs({ 'h', 'j', 'k', 'l' }) do
  vim.keymap.set('n', '<C-' .. dir .. '>', function()
    M.move(dir)
  end, { noremap = true, silent = true, desc = 'Smart window move (' .. dir .. ')' })
  -- terminal-job モードからは <C-\><C-n> で先に terminal-normal に抜けてから移動する
  -- (Lua コールバック内での stopinsert だと後続の startinsert が効かないため)
  vim.keymap.set('t', '<C-' .. dir .. '>',
    [[<C-\><C-n><Cmd>lua require('win_nav').move(']] .. dir .. [[')<CR>]],
    { noremap = true, silent = true, desc = 'Smart window move (' .. dir .. ')' })
end

return M
