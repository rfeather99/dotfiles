if empty(globpath(&rtp, 'autoload/fzf'))
  finish
endif

let $FZF_DEFAULT_COMMAND='ag --hidden --ignore .git --ignore node_modules -g ""'
let $FZF_DEFAULT_OPTS="--border --reverse --bind ctrl-f:page-down,ctrl-b:page-up"

command! -bang -nargs=* Pattern
\ call fzf#vim#grep(
\   'ag --no-heading --no-break --hidden --ignore .git --ignore node_modules --color '.shellescape(<q-args>), 1,
\   fzf#vim#with_preview(), <bang>0)

function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

command! BD call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
\ }))

nnoremap <silent> zb :Buffers<CR>
nnoremap <silent> zd :BD<CR>
nnoremap <silent> zf :Files<CR>
nnoremap zg :Pattern<Space>
nnoremap <silent> zl :BLines<CR>
nnoremap <silent> zh :History<CR>

