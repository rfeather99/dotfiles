-- 1. LSP Sever management
local rootPathRelatedHome = string.gsub(vim.fn.getcwd(), os.getenv("HOME").."/" ,"")
require('mason').setup({
  install_root_dir = require("mason-core.path").concat { vim.fn.stdpath "data", "mason", rootPathRelatedHome},
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})
require('mason-lspconfig').setup {
  ensure_installed = {
    'typos_lsp'
  }
}
vim.lsp.config("lua_ls", {
    settings = {
      Lua = {
        -- 「undefined global vim」を無視する
        diagnostics = {
          globals = { "vim" }
        }
      }
    }
  })
vim.lsp.config("pylsp", {
    root_markers = {"settings.py", ".git"},
    settings = {
      pylsp = {
        plugins = {
          pyflakes = {
            enabled = false
          },
          flake8 = {
            enabled = false
          },
          pycodestyle = {
            enabled = false
          },
        }
      }
    }
  })
-- monorepoで、ルートと配下でrubyバージョンが異なる場合に問題があったので、Masonを利用しない設定に変更
-- ただし、LSPを有効にするためには、Masonでインストールする必要がある(でも実際は使われない)
-- 参照: https://github.com/williamboman/mason.nvim/issues/1777
--

-- projectごとの、.vimrc.localで定義されていればそれを使う(dockerでlspを起動したい場合(ローカルだとbundle installができない)を想定)
-- 未定義または空ならデフォルトにフォールバック
local ruby_lsp_cmd = vim.g.ruby_lsp_cmd
if ruby_lsp_cmd == nil or #ruby_lsp_cmd == 0 then
  ruby_lsp_cmd = { vim.fn.expand("~/.rbenv/shims/ruby-lsp") }
end

vim.lsp.config("ruby_lsp", {
    mason = false, -- mason を無効化して、rbenv を利用
    cmd = ruby_lsp_cmd,
    root_markers = {"Gemfile", ".git"},
    settings = {
      rubyLsp = {
        diagnostics = {
          enabled = true,
          rubocopPath = vim.fn.expand("~/.rbenv/shims/rubocop"),
        },
      }
    }
  })
vim.lsp.config("rubocop", {
    mason = false, -- mason を無効化
    cmd = { vim.fn.expand("~/.rbenv/shims/rubocop"), "--lsp" },
    root_markers = {"Gemfile", ".git"}
  })
vim.lsp.config("solargraph", {
    mason = false, -- mason を無効化して、rbenv を利用
    cmd = { vim.fn.expand("~/.rbenv/shims/solargraph"), "stdio" },
    root_markers = {"Gemfile", ".git"},
    settings = {
      solargraph = {
        diagnostics = true, -- LSP による診断を有効化
        completion = true, -- 補完機能を有効化
        formatting = true, -- フォーマット機能を有効化
      }
    }
  })

-- mason-lspconfigでインストール済みサーバーを自動有効化
local mason_lspconfig = require('mason-lspconfig')
local servers = mason_lspconfig.get_installed_servers()
for _, server in ipairs(servers) do
  -- jdtlsは除外(nvim-jdtlsを使用するため)
  if server ~= "jdtls" then
    vim.lsp.enable(server)
  end
end

-- 2. build-in LSP function
-- keyboard shortcut
vim.keymap.set('n', 'K',  '<cmd>lua vim.lsp.buf.hover()<CR>')
vim.keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.format({async=false})<CR>')
vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references({includeDeclaration = false})<CR>')
vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
vim.keymap.set('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>')
vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
vim.keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>')
vim.keymap.set('n', 'g]', '<cmd>lua vim.diagnostic.jump({ count = 1, float = true })<CR>')
vim.keymap.set('n', 'g[', '<cmd>lua vim.diagnostic.jump({ count = -1, float = true })<CR>')
-- LSP handlers
vim.diagnostic.config({
  virtual_text = true,
})

-- 3. completion (hrsh7th/nvim-cmp)
local cmp = require("cmp")
local lspkind = require('lspkind')
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "omni" },
    { name = "buffer" },
    { name = "path" },
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ['<C-l>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm { select = true },
  }),
  experimental = {
    ghost_text = true,
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol', -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function (_, vim_item)
        return vim_item
      end
    })
  },
})
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "path" },
    { name = "cmdline" },
  },
})

-- diagnostics
require("trouble").setup {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
  signs = {
      -- icons / text used for a diagnostic
      error = "E",
      warning = "W",
      hint = "H",
      information = "",
      other = "O"
  },
}
