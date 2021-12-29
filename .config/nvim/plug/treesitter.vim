if empty(globpath(&rtp, 'autoload/nvim_treesitter.vim'))
  finish
endif

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = true, -- これを設定することでtree-sitterによるインデントを有効にできます
  },
}
EOF

