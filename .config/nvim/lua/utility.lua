local M = {}

function M.selected_path_range()
  local filepath = vim.fn.expand("%:.")
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")

  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  local text
  if start_line == end_line then
    text = string.format("%s:%d", filepath, start_line)
  else
    text = string.format("%s:%d-%d", filepath, start_line, end_line)
  end

  vim.fn.setreg("+", text)
  vim.cmd("normal! \27")
end

vim.api.nvim_create_user_command("MySelectedPathRange", M.selected_path_range, {})
vim.keymap.set("v", "<leader>y", "<cmd>MySelectedPathRange<CR>", { desc = "yank selected parh range", silent = true })

return M
