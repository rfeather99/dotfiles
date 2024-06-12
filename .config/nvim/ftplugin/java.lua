-- Javaファイルのインデントをスペース4に設定
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = true

-- Mason+nvim-jdtlsの設定。Masonで以下をインストールしておく
--  - jdtls
--  - java-debug-adapter
local mason_project_path = require("mason.settings").current.install_root_dir
local jdt_path = require("mason-core.path").concat { mason_project_path, "bin", "jdtls"}
local dap_path = vim.fn.glob(
  require("mason-core.path").concat {
    mason_project_path, "packages/java-debug-adapter/extension/server", "com.microsoft.java.debug.plugin-*.jar"
  }, 1)
local lombok_path = vim.fn.glob(
  require("mason-core.path").concat {
    mason_project_path, "packages/jdtls/lombok.jar"
  }, 1)
local config = {
    cmd = { jdt_path, "--jvm-arg=-javaagent:" .. lombok_path },
    root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
    init_options = {
        bundles = {
            dap_path
        };
    }
}
require('jdtls').start_or_attach(config)

-- vim-testで日本語のテスト名を使えるようにする
local line_start = [[\v^\s*]]
local optional_test_decorator = [[%(\zs\@Test\s+\ze)?]]
local optional_public_modifier = [[%(\zspublic\s+\ze)?]]
-- \wを\kに変更している。
local function_def = [[void\s+(\k+)]]
local class_def = [[class\s+(\w+)]]

local test_patterns = {
  test = {
    line_start .. optional_test_decorator .. optional_public_modifier .. function_def
  },
  namespace = {
    line_start .. optional_public_modifier .. class_def
  },
}

vim.g['test#java#patterns'] = test_patterns

-- DomaのSQLファイルとJavaファイルを行き来するための関数
function OpenDomaSqlFile()
  -- get medhot name at the cursor using treesitter
  local parser = vim.treesitter.get_parser(0, 'java')
  local tree = parser:parse()[1]
  local root = tree:root()
  local query = vim.treesitter.query.parse('java', [[
    (method_declaration name: (identifier) @method.name)
  ]])

  local method_name = nil
  local current_row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  current_row = current_row - 1

  for id, node in query:iter_captures(root, 0, current_row, current_row+1) do
    if query.captures[id] == "method.name" then
      method_name = vim.treesitter.get_node_text(node, 0)
      break
    end
  end

  -- generate query file path
  local file_path = vim.api.nvim_buf_get_name(0)

  local query_path = nil
  if file_path and method_name then
    query_path = string.gsub(file_path, "src/main/java/", "src/main/resources/META-INF/")
    query_path = string.gsub(query_path, "%.java$", "/" .. method_name .. ".sql")
  else
    print("Unable to find full method info at the cursor.")
    return
  end
  -- open the query file
  if query_path and vim.fn.filereadable(query_path) == 1 then
    vim.cmd("edit " .. query_path)
  else
    print("Unable to find the query file.")
  end
end

function JumpToDomaMethodFromSql()
    -- 現在のファイルパスを取得
    local path = vim.fn.expand('%:p')
    -- SQLファイルパスからJavaファイルパスに変換
    local javaFilePath = path
        :gsub("src/main/resources/META%-INF", "src/main/java") -- ベースパスの変更
        :gsub("/[^/]+%.sql$", ".java") -- ファイル名の変更 ('/test.sql' を '.java' に)

    -- メソッド名をファイル名から導出
    local methodName = vim.fn.expand('%:t:r')

  -- open the query file
  if javaFilePath and vim.fn.filereadable(javaFilePath) == 1 then
    -- Javaファイルを開く
    vim.cmd('edit ' .. javaFilePath)

    -- メソッド名を検索し、最初に見つかった場所にジャンプ
    vim.fn.search('\\v^\\s*(public\\s+|protected\\s+|private\\s+|static\\s+|default\\s+)?(\\w+\\s+)?' .. methodName .. '\\s*\\(', 'w')
  else
    print("Unable to find the java file.")
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java,sql",
  callback = function()
    vim.api.nvim_create_user_command('Doma',
    function()
      -- filetypeがjavaの場合、DomaのSQLファイルを開く
      -- filetypeがsqlの場合、Javaファイルを開く
      if vim.fn.expand('%:e') == 'java' then
        OpenDomaSqlFile()
      else
        JumpToDomaMethodFromSql()
      end
    end,
    {})
  end
})
