if empty(globpath(&rtp, 'autoload/vaffle'))
  finish
endif

" Gitステータスと、アイコンを表示する
function! RenderMyFavoriteIcon(item)
  return printf('%s%s ',
      \ GitStatus(a:item),
      \ WebDevIconsGetFileTypeSymbol(a:item.basename, a:item.is_dir))
endfunction

" Gitステータスによって表示するマークを設定
function! GitStatus(item)
  let git_status = system('git status -s ' . a:item.path)[0:1]

  if git_status == ' M' " modified
    return '+'
  elseif git_status =~ '\v(M|A|C).' " staged
    return '●'
  elseif git_status == 'R.' " renamed
    return '➜'
  elseif git_status =~ '\v(UU|AA|DD)' " unmarged
    return '═'
  elseif git_status == ' D' " deleted
    return 'x'
  elseif git_status == '??' " untracked
    return '?'
  elseif git_status == '!!' " ignore
    return ' '
  elseif git_status == 'X ' " unknown
    return '?'
  else
    return ' '
  endif
endfunction

let g:vaffle_auto_cd = 1
let g:vaffle_show_hidden_files = 1
let g:vaffle_use_default_mappings = 0
let g:vaffle_render_custom_icon = 'RenderMyFavoriteIcon'

nnoremap <silent> <C-e> :<C-u>Vaffle<CR>

function! s:customize_vaffle_mappings() abort
  " Customize key mappings here
  nmap <buffer> h        <Plug>(vaffle-open-parent)
  nmap <buffer> l        <Plug>(vaffle-open-current)
  nmap <buffer> <Tab>    <Plug>(vaffle-toggle-current)
  vmap <buffer> <Tab>    <Plug>(vaffle-toggle-current)

  nmap <buffer> <CR>     <Plug>(vaffle-open-selected)
  nmap <buffer> m        <Plug>(vaffle-move-selected)
  nmap <buffer> d        <Plug>(vaffle-delete-selected)
  nmap <buffer> r        <Plug>(vaffle-rename-selected)

  nmap <buffer> q        <Plug>(vaffle-quit)
  nmap <buffer> x        <Plug>(vaffle-fill-cmdline)

  nmap <buffer> K        <Plug>(vaffle-mkdir)
  nmap <buffer> N        <Plug>(vaffle-new-file)
endfunction

augroup vimrc_vaffle
  autocmd!
  autocmd FileType vaffle call s:customize_vaffle_mappings()
augroup END

