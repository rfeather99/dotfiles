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
set cursorline      "カーソル行の背景色を変える
"set cursorcolumn   "カーソル位置のカラムの背景色を変える
set title           "編集中のファイル名を表示する
set showcmd         "入力中のコマンドを表示する
set cmdheight=2     "コマンド入力欄の行数を2行にする
set shortmess+=c
set ruler           "座標を表示する
set showmatch       "閉じ括弧の入力時に対応する括弧を表示する
set list            "不可視文字を表示
set listchars=tab:▸\ ,eol:↲,extends:❯,precedes:❮ " 不可視文字の表示記号指定
set foldmethod=indent "折りたたみ範囲の判断基準（デフォルト: manual）
set foldlevel=100     "ファイルを開いたときにデフォルトで折りたたむレベル

" カーソル移動関連の設定
set backspace=indent,eol,start " Backspaceキーの影響範囲に制限を設けない
set whichwrap=b,s,h,l,<,>,[,]  " 行頭行末の左右移動で行をまたぐ

" ファイル処理関連の設定
filetype plugin on
set confirm    " 保存されていないファイルがあるときは終了前に保存確認
set hidden     " 保存されていないファイルがあるときでも別のファイルを開くことが出来る
set autoread   "外部でファイルに変更がされた場合は読みなおす
set nobackup   " ファイル保存時にバックアップファイルを作らない
set noswapfile " ファイル編集中にスワップファイルを作らない

" タブインデント設定
set expandtab     "タブ入力を複数の空白入力に置き換える
set tabstop=2     "画面上でタブ文字が占める幅
set shiftwidth=2  "自動インデントでずれる幅
set softtabstop=2 "連続した空白に対してタブキーやバックスペースキーでカーソルが
set autoindent    "改行時に前の行のインデントを継続する
set smartindent   "改行時に入力された行の末尾に合わせて次の行のインデントを増減す

"clipboad連携設定
"set clipboard=unnamed,autoselect
set clipboard+=unnamed

" 検索関連
set ignorecase  "大文字小文字の区別をしない
set smartcase   "大文字は小文字と区別する(ignorecaseとセット)

" neovimのfloating window関連
" set pumblend=20 "popup windowが半透明になる
" set winblend=10 "floating windowが半透明になる

"---------------------------------------------------------------
" キーマップ変更

" leaderを<Space>に設定
let mapleader = "\<Space>"

" <Space>oを押して新しいファイルを開く
nnoremap <Leader>o :enew<CR>
" <Space>wを押してファイルを保存する
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
" <Space><Space>でビジュアルラインモードに切り替える
nmap <Leader><Leader> V

"x時にyankされないようにする
nnoremap x "_x
nnoremap X "_X

" INSERTモードから抜けるときにESCの代わりにjjをつかう
inoremap <silent> jj <ESC>

" defaultファイラーを起動するショートカット
" nnoremap <C-n> :e .<CR>
" inoremap <C-n> <ESC>:e .<CR>

" Visualモードで選択からインデントの上げ下げを連続でできるようにする
vnoremap < <gv
vnoremap > >gv

" 検索時にデフォルトでvery magicを有効にする
nnoremap /  /\v

" 検索中の文字を置換する
nnoremap # :%s///gc<left><left><left>

"---------------------------------------------------------------
" 設定ファイルの読み込み
let s:source_rc = 'source ' . $HOME . '/.config/nvim/'
let s:load_rc   = {file -> execute(s:source_rc . file . '.vim')}
call s:load_rc('dein')                " プラグインの読み込み
call s:load_rc('tab')                 " TAB設定
call s:load_rc('utility')             " TAB設定

"---------------------------------------------------------------
" set background=light
syntax enable "シンタックスカラーリングを設定する

