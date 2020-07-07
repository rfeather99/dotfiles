if empty(globpath(&rtp, 'autoload/vaffle'))
  finish
endif

" Gitステータスと、アイコンを表示する
function! RenderMyFavoriteIcon(item)
  return printf('%s%s ',
      \ vaffle#git_statusses(a:item),
      \ WebDevIconsGetFileTypeSymbol(a:item.basename, a:item.is_dir))
endfunction

" Gitステータスによって表示するマークを設定
function! vaffle#git_statusses(item) abort
  let git_status = system('git status -s ' . a:item.path)[0:1]
  return vaffle#git_mark(git_status)
endfunction

function! vaffle#git_mark(mark_text) abort
  if a:mark_text == ' M' " modified
    return '+'
  elseif a:mark_text =~ '\v(M|A|C).' " staged
    return '●'
  elseif a:mark_text == 'R.' " renamed
    return '➜'
  elseif a:mark_text =~ '\v(UU|AA|DD)' " unmarged
    return '═'
  elseif a:mark_text == ' D' " deleted
    return 'x'
  elseif a:mark_text == '??' " untracked
    return '?'
  elseif a:mark_text == '!!' " ignore
    return ' '
  elseif a:mark_text == 'X ' " unknown
    return '?'
  else
    return ' '
  endif
endfunction

let g:vaffle_auto_cd = 0
let g:vaffle_show_hidden_files = 1
let g:vaffle_use_default_mappings = 0
let g:vaffle_render_custom_icon = 'RenderMyFavoriteIcon'
let g:vaffle_current = ''

nnoremap <silent> <C-e> :<C-u>execute 'Vaffle '.g:vaffle_current<CR>

function! MyOpenSelected() abort
  let filer = vaffle#buffer#get_filer()
  let item = filer.items[line('.') - 1]
  let g:vaffle_current = item.path
  call vaffle#open_selected('')
endfunction

function! MyOpenParent() abort
  let filer = vaffle#buffer#get_filer()
  let g:vaffle_current = fnameescape(fnamemodify(filer.dir, ':h'))
  call vaffle#open_parent()
endfunction

function! s:customize_vaffle_mappings() abort
  " Customize key mappings here
  nmap <silent> <buffer> h  :<C-u>call MyOpenParent()<CR>
  nmap <silent> <buffer> l  :<C-u>call MyOpenSelected()<CR>
  nmap <buffer> <Tab>       <Plug>(vaffle-toggle-current)
  vmap <buffer> <Tab>       <Plug>(vaffle-toggle-current)

  nmap <buffer> <CR>        <Plug>(vaffle-open-selected)
  nmap <buffer> m           <Plug>(vaffle-move-selected)
  nmap <buffer> d           <Plug>(vaffle-delete-selected)
  nmap <buffer> r           <Plug>(vaffle-rename-selected)

  nmap <buffer> q           <Plug>(vaffle-quit)
  nmap <buffer> x           <Plug>(vaffle-fill-cmdline)

  nmap <buffer> K           <Plug>(vaffle-mkdir)
  nmap <buffer> N           <Plug>(vaffle-new-file)
endfunction

augroup vimrc_vaffle
  autocmd!
  autocmd FileType vaffle call s:customize_vaffle_mappings()
augroup END

