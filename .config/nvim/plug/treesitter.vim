if empty(globpath(&rtp, 'autoload/nvim_treesitter.vim'))
  finish
endif

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {},
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = false, -- これを設定することでtree-sitterによるインデントを有効にできます
  },
}
EOF

" thorはrubyのシンタックス
au BufRead,BufNewFile *.thor set filetype=ruby
au BufRead,BufNewFile Thorfile set filetype=ruby

