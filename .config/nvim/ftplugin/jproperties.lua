-- Javaのpropertiesファイルを日本語のまま編集できるようにする。
-- 読み込み時に \uXXXX を実際の文字へデコードし、保存時(BufWriteCmd)に
-- 非ASCII文字を \uXXXX (native2ascii互換の小文字hex)へエンコードして書き込む。
-- バッファは日本語のまま保つので、保存で表示が乱れたりundo履歴が汚れたりしない。
-- :PropertiesAsciiToggle で変換の有効/無効を切り替えられる(vim.b.properties_ascii)。

local bufnr = vim.api.nvim_get_current_buf()

-- pos位置の \uXXXX を読み取ってコードポイントを返す。該当しなければnil
local function parse_escape(line, pos)
  if line:sub(pos, pos + 1) ~= '\\u' then
    return nil
  end
  local hex = line:sub(pos + 2, pos + 5)
  if not hex:match('^%x%x%x%x$') then
    return nil
  end
  return tonumber(hex, 16)
end

-- \uXXXX → 実際の文字。\\ (エスケープされたバックスラッシュ)の直後は変換しない
local function decode_line(line)
  local out, i, n = {}, 1, #line
  while i <= n do
    local bs = line:find('\\', i, true)
    if not bs then
      out[#out + 1] = line:sub(i)
      break
    end
    out[#out + 1] = line:sub(i, bs - 1)
    if line:sub(bs + 1, bs + 1) == '\\' then
      out[#out + 1] = '\\\\'
      i = bs + 2
    else
      local cp = parse_escape(line, bs)
      if not cp then
        out[#out + 1] = '\\'
        i = bs + 1
      else
        local len = 6
        if cp >= 0xD800 and cp <= 0xDBFF then
          -- サロゲートペアは結合して1文字に復元する
          local lo = parse_escape(line, bs + 6)
          if lo and lo >= 0xDC00 and lo <= 0xDFFF then
            cp = 0x10000 + (cp - 0xD800) * 0x400 + (lo - 0xDC00)
            len = 12
          else
            cp = nil
          end
        elseif cp >= 0xDC00 and cp <= 0xDFFF then
          cp = nil
        end
        if cp then
          out[#out + 1] = vim.fn.nr2char(cp, 1)
          i = bs + len
        else
          -- 孤立サロゲートは不正なUTF-8になるため変換せずそのまま残す
          out[#out + 1] = line:sub(bs, bs + 5)
          i = bs + 6
        end
      end
    end
  end
  return table.concat(out)
end

-- 非ASCII文字 → \uXXXX。U+FFFF超はサロゲートペア2つに分割する
local function encode_line(line)
  if not line:find('[\128-\255]') then
    return line
  end
  local out = {}
  for _, cp in ipairs(vim.fn.str2list(line, 1)) do
    if cp < 0x80 then
      out[#out + 1] = string.char(cp)
    elseif cp <= 0xFFFF then
      out[#out + 1] = string.format('\\u%04x', cp)
    else
      local v = cp - 0x10000
      out[#out + 1] = string.format('\\u%04x\\u%04x',
        0xD800 + math.floor(v / 0x400), 0xDC00 + v % 0x400)
    end
  end
  return table.concat(out)
end

local function decode_buffer()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local changed = false
  for idx, line in ipairs(lines) do
    if line:find('\\u', 1, true) then
      local decoded = decode_line(line)
      if decoded ~= line then
        lines[idx] = decoded
        changed = true
      end
    end
  end
  if not changed then
    return
  end
  local view = vim.fn.winsaveview()
  local was_modified = vim.bo[bufnr].modified
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.fn.winrestview(view)
  -- デコードは表示上の変換なのでmodified扱いにしない
  if not was_modified then
    vim.bo[bufnr].modified = false
  end
end

if vim.b[bufnr].properties_ascii ~= false then
  decode_buffer()
end

-- 保存処理を置き換えて、エンコードした内容をディスクへ書き込む
local group = vim.api.nvim_create_augroup('jproperties_ascii', { clear = false })
vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
vim.api.nvim_create_autocmd('BufWriteCmd', {
  group = group,
  buffer = bufnr,
  callback = function(args)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    if vim.b[bufnr].properties_ascii ~= false then
      for idx, line in ipairs(lines) do
        lines[idx] = encode_line(line)
      end
    end
    if vim.fn.writefile(lines, args.file) ~= 0 then
      vim.notify('書き込みに失敗しました: ' .. args.file, vim.log.levels.ERROR)
      return
    end
    -- 自分自身のファイルへの保存なら :w 相当としてmodifiedを落とす
    if vim.fn.fnamemodify(args.file, ':p') == vim.api.nvim_buf_get_name(bufnr) then
      vim.bo[bufnr].modified = false
    end
    print(string.format('"%s" %dL written', args.file, #lines))
  end,
})

vim.api.nvim_buf_create_user_command(bufnr, 'PropertiesAsciiToggle', function()
  vim.b[bufnr].properties_ascii = vim.b[bufnr].properties_ascii == false
  if vim.b[bufnr].properties_ascii then
    decode_buffer()
    vim.notify('properties: 保存時に \\uXXXX へ変換します')
  else
    vim.notify('properties: 変換を無効にしました(そのまま保存します)')
  end
end, { desc = 'propertiesファイルの\\uXXXX変換を切り替える' })
