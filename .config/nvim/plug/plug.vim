let s:plug_dir = expand('~/.local/share/nvim/site/plugged')

"" 以下pluginの設定

" accelerated-jk
if !empty(globpath(&rtp, 'autoload/accelerated'))
  nmap j <Plug>(accelerated_jk_gj)
  nmap k <Plug>(accelerated_jk_gk)
endif

" easymotion
if !empty(globpath(&rtp, 'autoload/easymotion'))
  " Do not rely on default bidings.
  let g:EasyMotion_do_mapping = 0
  " Turn on case sensitive feature
  let g:EasyMotion_smartcase = 1

  nmap s <Plug>(easymotion-overwin-f2)
  xmap s <Plug>(easymotion-overwin-f2)
  omap z <Plug>(easymotion-overwin-f2)

  nmap g/ <Plug>(easymotion-sn)
  xmap g/ <Plug>(easymotion-sn)
  omap g/ <Plug>(easymotion-tn)
endif

" vim-airline
if !empty(globpath(&rtp, 'autoload/airline'))
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#ale#enabled = 1
  let g:airline#extensions#ale#error_symbol = '❌'
  let g:airline#extensions#ale#warning_symbol = '⚠️ '
  set laststatus=2
endif

" previm
function! s:open_preview(path) abort
  let b:previm_opened = 1
  call previm#refresh()

  let l:result =  system("lsof -i:8080")
  if len(l:result) == 0
    execute 'split | wincmd j | resize 20 | term npx http-server ' . previm#preview_base_dir()
  endif
  echo "http://localhost:8080/" . substitute(a:path, previm#preview_base_dir(), "", "g")

  augroup PrevimCleanup
    au!
    au VimLeave * call previm#wipe_cache_for_self()
  augroup END
endfunction

function! s:setup_previm() abort
  command! -nargs=0 P call s:open_preview(previm#make_preview_file_path('index.html'))
endfunction
augroup PV
  autocmd!
  autocmd FileType *{mkd,markdown,mmd,mermaid,rst,textile,asciidoc,plantuml,html}* call s:setup_previm()
augroup END


lua <<EOF
require("ibl").setup {
  indent = { char = "⋅" },
  scope = { enabled = false },
}

require('aerial').setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', {buffer = bufnr})
    vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', {buffer = bufnr})
  end,
  layout = {
    default_direction = 'prefer_left',
  }
})
-- You probably also want to set a keymap to toggle aerial
vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>')
EOF

" copilot
if !empty(globpath(&rtp, 'autoload/copilot'))
  let g:copilot_node_command = '/opt/homebrew/bin/node'
  let g:copilot_assume_mapped = v:true
endif
