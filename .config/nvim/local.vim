" .vmirc.local
" サンプル
"
" let g:ale_fix_on_save = 0
" let g:lsp_diagnostics_virtual_text_enabled = 0
"
" Load settings for each location.
function! s:vimrc_local(loc)
  let files = findfile('.vimrc.local', escape(a:loc, ' ') . ';', -1)
  for i in reverse(filter(files, 'filereadable(v:val)'))
    source `=i`
  endfor
endfunction
call s:vimrc_local(expand('<afile>:p:h'))

