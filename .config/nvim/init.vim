scriptencoding utf-8

" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

" 文字設定
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
set fileformats=unix,dos,mac

" エディタ設定
set number          "行番号を表示する
set cursorline      " カーソル行の背景色を変える
"set cursorcolumn   " カーソル位置のカラムの背景色を変える

set title     "編集中のファイル名を表示する
set showcmd   "入力中のコマンドを表示する
set ruler     "座標を表示する
set showmatch "閉じ括弧の入力時に対応する括弧を表示する

" カーソル移動関連の設定
set backspace=indent,eol,start " Backspaceキーの影響範囲に制限を設けない
set whichwrap=b,s,h,l,<,>,[,]  " 行頭行末の左右移動で行をまたぐ

" ファイル設定
filetype plugin on
set nobackup
set noundofile

" タブインデント設定
set expandtab     "タブ入力を複数の空白入力に置き換える
set tabstop=2     "画面上でタブ文字が占める幅
set shiftwidth=2  "自動インデントでずれる幅
set softtabstop=2 "連続した空白に対してタブキーやバックスペースキーでカーソルが
set autoindent    "改行時に前の行のインデントを継続する
set smartindent   "改行時に入力された行の末尾に合わせて次の行のインデントを増減す

"clipboad連携設定
"set clipboard=unnamed,autoselect
"set clipboard+=unnamed

"---------------------------------------------------------------
" キーマップ変更

"x時にyankされないようにする
nnoremap x "_x
nnoremap X "_X

" INSERTモードから抜けるときにESCの代わりにjjをつかう
inoremap <silent> jj <ESC>

" defaultファイラーを起動するショートカット
" nnoremap <C-n> :e .<CR>
" inoremap <C-n> <ESC>:e .<CR>

"---------------------------------------------------------------
" 設定ファイルの読み込み
let s:source_rc = 'source ' . $HOME . '/.config/nvim/'
let s:load_rc   = {file -> execute(s:source_rc . file . '.vim')}
call s:load_rc('dein')                " プラグインの読み込み
call s:load_rc('tab')                 " TAB設定

"---------------------------------------------------------------
" set background=light
syntax enable "シンタックスカラーリングを設定する

