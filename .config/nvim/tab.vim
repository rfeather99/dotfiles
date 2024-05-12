scriptencoding utf-8

"**************************
" タブ関連の設定
"**************************
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction
" tablineの設定
function! s:my_tabline() "{{{
  let l:s = ''
  for l:i in range(1, tabpagenr('$'))
    let l:bufnrs = tabpagebuflist(i)
    let l:bufnr = l:bufnrs[tabpagewinnr(i) - 1] " first window, first appears
    let l:no = i " display 0-origin tabpagenr.
    let l:mod = getbufvar(l:bufnr, '&modified') ? '!' : ' '
    let l:title = fnamemodify(bufname(l:bufnr), ':t')
    let l:title = '[' . l:title . ']'
    let l:s .= '%' . i . 'T'
    let l:s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let l:s .= no . ':' . l:title
    let l:s .= mod
    let l:s .= '%#TabLineFill# '
  endfor
  let l:s .= '%#TabLineFill#%T%=%#TabLine#'
  return l:s
endfunction "}}}
let &tabline = '%!' . s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " タブラインを常に表示

" The prefix key.
nnoremap [Tag] <Nop>
nmap t [Tag]

" Tab jump
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor

map <silent> [Tag]c :tablast <bar> tabnew<CR> " tc 新しいタブを一番右に作る
" tx タブを閉じる
map <silent> [Tag]x :tabclose<CR>
" tn 次のタブ
map <silent> [Tag]n :tabnext<CR>
" 前のタブ
map <silent> [Tag]p :tabprevious<CR>

