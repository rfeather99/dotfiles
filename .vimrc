"Display設定
"syntax enable "シンタックスカラーリングを設定する
"set background=light
"colorscheme morning

" 文字設定
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
set fileformats=unix,dos,mac

" エディタ設定
set clipboard=unnamed,autoselect
set number    "行番号を表示する
set cursorline     " カーソル行の背景色を変える
"set cursorcolumn   " カーソル位置のカラムの背景色を変える

set title    "編集中のファイル名を表示する
set showcmd    "入力中のコマンドを表示する
set ruler    "座標を表示する
set showmatch   "閉じ括弧の入力時に対応する括弧を表示する
"set lines=50
"set columns=80

" カーソル移動関連の設定
set backspace=indent,eol,start " Backspaceキーの影響範囲に制限を設けない
set whichwrap=b,s,h,l,<,>,[,]  " 行頭行末の左右移動で行をまたぐ

" ファイル設定
set nobackup
set noundofile

" タブインデント設定
set expandtab "タブ入力を複数の空白入力に置き換える
set tabstop=2 "画面上でタブ文字が占める幅
set shiftwidth=2 "自動インデントでずれる幅
set softtabstop=2 "連続した空白に対してタブキーやバックスペースキーでカーソルが
set autoindent "改行時に前の行のインデントを継続する
set smartindent "改行時に入力された行の末尾に合わせて次の行のインデントを増減す

"clipboad連携設定
set clipboard+=unnamed

"**************************
" プラグインマネージャの設定
"**************************
let s:dein_dir = expand('~/.cache/dein')
let s:dein = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
"deinの存在確認＆なければインストール
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein
  endif
  execute 'set runtimepath+=' . s:dein
endif
"deinの設定
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  "pluginリストの読み込み
  let s:dein_conf = s:dein_dir . '/dein.toml'
  let s:dein_lazy_conf = s:dein_dir . '/dein_lazy.toml'

  if filereadable(s:dein_conf)
    call dein#load_toml(s:dein_conf,{'lazy':0})
  endif
  if filereadable(s:dein_lazy_conf)
    call dein#load_toml(s:dein_lazy_conf, {'lazy': 1})
  endif
  "設定の保存
  call dein#end()
  call dein#save_state()
endif
"未インストールのpluginをダウンロード
if dein#check_install()
  call dein#install()
endif

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
" set showtabline = 2 " タブラインを常に表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]

" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]c :tablast <bar> tabnew<CR> " tc 新しいタブを一番右に作る
map <silent> [Tag]x :tabclose<CR>             " tx タブを閉じる
map <silent> [Tag]n :tabnext<CR>              " tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>          " tp 前のタブ


syntax enable "シンタックスカラーリングを設定する

