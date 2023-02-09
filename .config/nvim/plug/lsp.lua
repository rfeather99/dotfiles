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
require('mason-lspconfig').setup_handlers({
  function(server)
    local opt = {
    }
    require('lspconfig')[server].setup(opt)
  end,
  pylsp = function()
    require("lspconfig").pylsp.setup {
      root_dir = function(fname)
        local root_files = {
          'settings.py',
        }
        return require("lspconfig.util").root_pattern(unpack(root_files))(fname) or require("lspconfig.util").find_git_ancestor(fname)
      end,
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
    }
  end,
})

-- 2. build-in LSP function
-- keyboard shortcut
vim.keymap.set('n', 'K',  '<cmd>lua vim.lsp.buf.hover()<CR>')
vim.keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.format({async=false})<CR>')
vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
vim.keymap.set('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>')
vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
vim.keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>')
vim.keymap.set('n', 'g]', '<cmd>lua vim.diagnostic.goto_next()<CR>')
vim.keymap.set('n', 'g[', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
-- LSP handlers
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = true }
)

-- 3. completion (hrsh7th/nvim-cmp)
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<S-Tab>"] = cmp.mapping.select_next_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ['<C-l>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm { select = true },
  }),
  experimental = {
    ghost_text = true,
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

-- 4. Formatter / Linter (null-ls)
local mason_package = require("mason-core.package")
local mason_registry = require("mason-registry")
local null_ls = require("null-ls")

local pypkg = { mypy=true, black=true, isort=true, pyproject_flake8=true, eslint_d=true }
local pypkg_cwd = function(params)
  local fname = params.bufname
  local util = require("lspconfig.util")
  local root_files = {
    "pyproject.toml",
    "package.json",
  }
  return util.root_pattern(unpack(root_files))(fname) or util.root_pattern ".git" (fname) or util.path.dirname(fname)
end

local null_sources = {}
for _, package in ipairs(mason_registry.get_installed_packages()) do
  local package_categories = package.spec.categories[1]
  local package_name = string.gsub(package.name, "-", "_")  -- null-lsのパッケージ名はアンダースコア

  if pcall(require, string.format("null-ls.builtins.formatting.%s", package_name)) then
    if pypkg[package_name] then
      table.insert(null_sources, null_ls.builtins.formatting[package_name].with({
        cwd = pypkg_cwd
      }))
    else
      table.insert(null_sources, null_ls.builtins.formatting[package_name])
    end
  end
  if package_categories == mason_package.Cat.Linter then
    if package_name == "mypy" then
      table.insert(null_sources, null_ls.builtins.diagnostics[package_name].with({
        extra_args = {"--show-absolute-path"},
        cwd = pypkg_cwd
      }))
    elseif pypkg[package_name] then
      table.insert(null_sources, null_ls.builtins.diagnostics[package_name].with({
        cwd = pypkg_cwd
      }))
    else
      table.insert(null_sources, null_ls.builtins.diagnostics[package_name])
    end
  end
end
local lsp_formatting = function(bufnr)
  vim.lsp.buf.format({
    timeout_ms = 2000,
    filter = function(client)
        -- apply whatever logic you want (in this example, we'll only use null-ls)
        return client.name == "null-ls"
    end,
    bufnr = bufnr,
  })
end

local augroup = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
null_ls.setup({
  sources = null_sources,
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
            lsp_formatting(bufnr)
        end,
      })
    end
  end,
})

-- diagnostics
require("trouble").setup {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
}
