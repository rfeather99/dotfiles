-- ~/.config/nvim/lua/terminal_toggle.lua
local M = {}

local terminal_bufnr = nil
local terminal_winid = nil
local TERMINAL_BUF_NAME = "TERMINAL_SIDE"

function M.toggle_terminal()
  -- すでに表示されているならウィンドウを閉じる
  if terminal_winid and vim.api.nvim_win_is_valid(terminal_winid) then
    vim.api.nvim_win_close(terminal_winid, true)
    terminal_winid = nil
    return
  end

  -- 既存の terminal バッファが存在しない場合は新規作成
  if not terminal_bufnr or not vim.api.nvim_buf_is_valid(terminal_bufnr) then
    -- いったん新しいウィンドウを下に追加
    vim.cmd("botright split")
    terminal_winid = vim.api.nvim_get_current_win()

    -- terminal 起動（この時点でバッファが作成される）
    vim.cmd("terminal")
    terminal_bufnr = vim.api.nvim_get_current_buf()

    -- 名前をつける
    vim.api.nvim_buf_set_name(terminal_bufnr, TERMINAL_BUF_NAME)

    -- ← ここで layout を左右にぶち抜く！
    vim.cmd("wincmd L")
    vim.api.nvim_win_set_width(terminal_winid, math.floor(vim.o.columns * 0.3))

    -- 挿入モードへ
    vim.cmd("startinsert")
    return
  end

  -- 再表示時：右側に新規 vsplit → terminal buf を再表示
  vim.cmd("vsplit")
  vim.cmd("wincmd L")  -- split 配置を右に追い出す
  terminal_winid = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(terminal_winid, terminal_bufnr)
  vim.api.nvim_win_set_width(terminal_winid, math.floor(vim.o.columns * 0.3))
  vim.cmd("startinsert")
end

vim.api.nvim_create_user_command("MyTerminalToggle", M.toggle_terminal, {})
vim.keymap.set("n", "<leader>0", "<cmd>MyTerminalToggle<CR>", { desc = "Toggle side terminal", silent = true })

return M
