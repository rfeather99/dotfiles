if empty(globpath(&rtp, 'autoload/fern'))
  finish
endif

let g:fern#default_hidden = 1
let g:fern#disable_default_mappings = 1
let g:fern#renderer = "nerdfont"

nnoremap <silent> <C-e> :<C-u>Fern . -reveal=%<CR>

function! s:init_fern() abort
  echo "This function is called ON a fern buffer WHEN initialized"

  " mark.vim
  nmap <buffer><nowait> <C-j> <Plug>(fern-action-mark)j
  nmap <buffer><nowait> <C-k> k<Plug>(fern-action-mark)
  nmap <buffer><nowait> -     <Plug>(fern-action-mark)
  vmap <buffer><nowait> -     <Plug>(fern-action-mark)

  " node.vim
  nmap <buffer><nowait> <F5> <Plug>(fern-action-reload)
  nmap <buffer><nowait> <C-m> <Plug>(fern-action-enter)
  nmap <buffer><nowait> <C-h> <Plug>(fern-action-leave)
  nmap <buffer><nowait> l <Plug>(fern-action-expand)
  nmap <buffer><nowait> h <Plug>(fern-action-collapse)
  nmap <buffer><nowait> i <Plug>(fern-action-reveal)
  nmap <buffer><nowait> <Return> <C-m>
  nmap <buffer><nowait> <Backspace> <C-h>

  " open.vim
  nmap <buffer><nowait> <C-m> <Plug>(fern-action-open-or-enter)
  nmap <buffer><nowait> l <Plug>(fern-action-open-or-expand)
  nmap <buffer><nowait> s <Plug>(fern-action-open:select)
  nmap <buffer><nowait> e <Plug>(fern-action-open)
  nmap <buffer><nowait> E <Plug>(fern-action-open:side)
  nmap <buffer><nowait> t <Plug>(fern-action-open:tabedit)

  " tree.vim
  nmap <buffer><nowait> <C-c> <Plug>(fern-action-cancel)
  nmap <buffer><nowait> <C-l> <Plug>(fern-action-redraw)

  " yank.vim
  nmap <buffer><nowait> y <Plug>(fern-action-yank)

  " scheme/file/mapping.vim
  nmap <buffer><nowait> N <Plug>(fern-action-new-file)
  nmap <buffer><nowait> K <Plug>(fern-action-new-dir)
  nmap <buffer><nowait> c <Plug>(fern-action-copy)
  nmap <buffer><nowait> m <Plug>(fern-action-move)
  nmap <buffer><nowait> D <Plug>(fern-action-remove)

  " scheme/file/mapping/clipboard.vim
  nmap <buffer><nowait> C <Plug>(fern-action-clipboard-copy)
  nmap <buffer><nowait> M <Plug>(fern-action-clipboard-move)
  nmap <buffer><nowait> P <Plug>(fern-action-clipboard-paste)

  " scheme/file/mapping/rename.vim
  nmap <buffer><nowait> R <Plug>(fern-action-rename)

  " scheme/file/mapping/system.vim
  nmap <buffer><nowait> x <Plug>(fern-action-open:system)
endfunction

augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END

