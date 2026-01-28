-- vim-test
vim.g["test#strategy"] = "neovim_sticky"

-- keymap
vim.keymap.set("n", "<leader>tt", ":TestNearest<CR>")
vim.keymap.set("n", "<leader>tT", ":TestFile<CR>")
vim.keymap.set("n", "<leader>tl", ":TestLast<CR>")

-- ルートパスを動的に取得する関数
function CustomPath()
  local current_dir = vim.fn.expand('%:p:h')
  -- ルートファイルのリスト
  local root_files = { 'pom.xml', 'Gemfile', 'pyproject.toml', 'package.json' }

  while current_dir ~= '/' and current_dir ~= '' do
    for _, file in ipairs(root_files) do
      if vim.fn.filereadable(current_dir .. '/' .. file) == 1 then
        return current_dir
      end
    end
    current_dir = vim.fn.fnamemodify(current_dir, ':h')
  end

  -- ルートファイルが見つからなかった場合は、現在の作業ディレクトリを返す
  return vim.fn.getcwd()
end

-- Lua関数をVimscriptから呼び出せるようにする
vim.cmd([[
  function! CustomPathWrapper() abort
    return luaeval("CustomPath()")
  endfunction
]])

-- test#project_root を設定するために Vim のグローバル変数にセット
vim.cmd([[
  let test#project_root = function('CustomPathWrapper')
]])
