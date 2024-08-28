local dap = require('dap')

-- アイコン設定
vim.fn.sign_define('DapBreakpoint', { text='', texthl='DapBreakpointTextHl' })
vim.fn.sign_define('DapStopped', { text='', texthl='DapStoppedTextHl' })

-- Replのcompletionを有効にする(CTRL-X CTRL-Oでも補完できる)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dap-repl",
  callback = function()
    require('dap.ext.autocompl').attach()
  end
})

-- ここにファイルタイプ別の設定
dap.configurations = {
  java = {
    -- 複数指定することもできる
    -- 複数あるとデバッグ開始時にどの設定使うか聞かれる
    {
      type = 'java';
      request = 'attach';
      name = "[5005] Debug (Attach) - Remote";
      hostName = "127.0.0.1";
      port = 5005;
    },
    {
      type = 'java';
      request = 'attach';
      name = "[5006] Debug (Attach) - Remote";
      hostName = "127.0.0.1";
      port = 5006;
    },
  }
}

vim.api.nvim_set_keymap('n', '<leader>c', ':DapContinue<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>n', ':DapStepOver<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>s', ':DapStepInto<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>u', ':DapStepOut<CR>', { silent = true })
-- vim.api.nvim_set_keymap('n', 'dc', ':DapContinue<CR>', { silent = true })
-- vim.api.nvim_set_keymap('n', 'dn', ':DapStepOver<CR>', { silent = true })
-- vim.api.nvim_set_keymap('n', 'ds', ':DapStepInto<CR>', { silent = true })
-- vim.api.nvim_set_keymap('n', 'do', ':DapStepOut<CR>', { silent = true })
--
-- vim.api.nvim_set_keymap('n', '<F5>', ':DapContinue<CR>', { silent = true })
-- vim.api.nvim_set_keymap('n', '<F10>', ':DapStepOver<CR>', { silent = true })
-- vim.api.nvim_set_keymap('n', '<F11>', ':DapStepInto<CR>', { silent = true })
-- vim.api.nvim_set_keymap('n', '<F12>', ':DapStepOut<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>b', ':DapToggleBreakpoint<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>B', ':lua require("dap").set_breakpoint(nil, nil, vim.fn.input("Breakpoint condition: "))<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>lp', ':lua require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>dr', ':lua require("dap").repl.open()<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>dl', ':lua require("dap").run_last()<CR>', { silent = true })

require("nvim-dap-virtual-text").setup()

-- プラグイン設定

-- telescope-dap設定
-- :DでTelescope dap <args>を実行する。引数がない場合はcommandsを実行する
require('telescope').load_extension('dap')

local dap_commands = {
  "commands",
  "configurations",
  "variables",
  "frames",
  "list_breakpoints",
}
_G.custom_commands = {}
function _G.custom_commands.dap_complete(arg_lead, cmd_line, cursor_pos)
  return vim.tbl_filter(function(val)
    return vim.startswith(val, arg_lead)
  end, dap_commands)
end
function _G.custom_commands.dap_command_handler(args)
  if args == "" then
    require('telescope').extensions.dap.commands({})
  else
    local tdap = require('telescope').extensions.dap
    if tdap[args] then
      tdap[args]({})
    else
      print("Invalid argument: " .. args)
    end
  end
end
vim.cmd([[
  command! -nargs=* -complete=customlist,v:lua._G.custom_commands.dap_complete D lua _G.custom_commands.dap_command_handler("<args>")
]])
