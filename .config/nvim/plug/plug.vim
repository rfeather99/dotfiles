let s:plug_dir = expand('~/.local/share/nvim/site/plugged')

"" 以下pluginの設定

" colorschemeの設定
if filereadable(expand(s:plug_dir . "/gruvbox/colors/gruvbox.vim"))
  au MyAutoCmd VimEnter * nested colorscheme gruvbox
endif

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

" vim-polyglot
if !empty(globpath(&rtp, 'autoload/csv.vim'))
  " csvは別のプラグインを使う
  let g:polyglot_disabled = ['csv']
  autocmd BufRead,BufNewFile *.csv setfiletype csv

  " vim-markdownのcode blockのconealを無効にする
  let g:vim_markdown_conceal_code_blocks = 0
endif

" ale
if !empty(globpath(&rtp, 'autoload/ale'))
  let g:ale_fixers = {
        \ 'javascript': ['eslint'],
        \ 'typescript': ['eslint'],
        \ 'vue': ['eslint'],
        \ 'ruby': ['rubocop']
        \ }
  let g:ale_fix_on_save = 1
endif


