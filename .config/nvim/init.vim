scriptencoding utf-8

" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

" 文字設定
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,cp932,sjis
set fileformats=unix,dos,mac

" エディタ設定
set number          "行番号を表示する
set signcolumn=yes  "行番号横のサイン列を常に表示する
set cursorline      "カーソル行の背景色を変える
set title           "編集中のファイル名を表示する
set showcmd         "入力中のコマンドを表示する
set cmdheight=1     "コマンド入力欄の行数を1行にする
set shortmess+=c
set ruler           "座標を表示する
set showmatch       "閉じ括弧の入力時に対応する括弧を表示する
set list            "不可視文字を表示
set listchars=tab:▸\ ,eol:↲,extends:❯,precedes:❮,space:⋅ " 不可視文字の表示記号指定
set foldmethod=indent "折りたたみ範囲の判断基準（デフォルト: manual）
set foldlevel=100     "ファイルを開いたときにデフォルトで折りたたむレベル
set completeopt=menuone,noinsert "completionの設定
set mouse=          "マウス操作不可にする

" カーソル移動関連の設定
set backspace=indent,eol,start " Backspaceキーの影響範囲に制限を設けない
set whichwrap=b,s,h,l,<,>,[,]  " 行頭行末の左右移動で行をまたぐ

" ファイル処理関連の設定
filetype plugin indent on
set confirm    " 保存されていないファイルがあるときは終了前に保存確認
set hidden     " 保存されていないファイルがあるときでも別のファイルを開くことが出来る
set autoread   "外部でファイルに変更がされた場合は読みなおす
set nobackup   " ファイル保存時にバックアップファイルを作らない
set noswapfile " ファイル編集中にスワップファイルを作らない

" ウィンドウ関連の設定
set splitbelow " 新しいウィンドウを下に開く
set splitright " 新しいウィンドウを右に開く

" タブインデント設定
set expandtab     "タブ入力を複数の空白入力に置き換える
set tabstop=2     "画面上でタブ文字が占める幅
set shiftwidth=2  "自動インデントでずれる幅
set softtabstop=2 "連続した空白に対してタブキーやバックスペースキーでカーソルが
set autoindent    "改行時に前の行のインデントを継続する
set smartindent   "改行時に入力された行の末尾に合わせて次の行のインデントを増減す
set breakindent   "行の折り返し時に、インデントを維持する

"clipboad連携設定
set clipboard+=unnamedplus

" 検索関連
set ignorecase  "大文字小文字の区別をしない
set smartcase   "大文字は小文字と区別する(ignorecaseとセット)

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

"選択領域にはりつけるときに、貼り付け先をyankしないようにする
xnoremap p pgvygv<esc>

" INSERTモードから抜けるときにESCの代わりにjjをつかう
inoremap <silent> jj <ESC>

" 検索時にデフォルトでvery magicを有効にする
nnoremap /  /\v

" 検索中の文字を置換する
nnoremap # :%s///gc<left><left><left>

" コマンドモードでemacsバインディングが使えるようにする
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
" 前の単語へ移動
cnoremap <M-b> <S-Left>
" 次の単語へ移動
cnoremap <M-f> <S-Right>

" バッファーを移動しやすくする
nnoremap <silent> <C-p> :bp<CR>
nnoremap <silent> <C-n> :b#<CR>

" quickfixを移動しやすくする
nnoremap <silent> <C-[> :cp<CR>
nnoremap <silent> <C-]> :cn<CR>

" terminalモードを使いやすくする
nnoremap <silent> <C-t> :term<CR>
tnoremap <Esc> <C-\><C-n>
tnoremap <C-]> <C-\><C-n>
command! -nargs=* T split | wincmd j | terminal <args>
autocmd TermOpen * startinsert

"---------------------------------------------------------------
" 設定ファイルの読み込み
runtime plug.vim   " プラグインの読み込み
runtime tab.vim    " TAB設定
runtime osc52.vim  " OSC52設定
runtime local.vim  " LOCAL設定の読み込み

"---------------------------------------------------------------
" agの結果をquickfixに流せるようにする
function! s:rg(word) abort
  cexpr system(printf('rg --column --hidden --no-heading --glob "!.git" --glob "!node_modules" --vimgrep "%s" .', a:word)) | cw
endfunction

command! -nargs=1 Rg call <SID>rg(<q-args>)

syntax enable "シンタックスカラーリングを設定する

