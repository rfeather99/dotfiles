scriptencoding utf-8

"**************************
" プラグインマネージャの設定
"**************************
let s:load_dir = expand('~/.local/share/nvim/site/autoload')
let s:plug_dir = expand('~/.local/share/nvim/site/plugged')

" Vimを開いた時にvim-plugを用意する
let s:plug = s:load_dir . '/plug.vim'
if has('vim_starting')
  if !isdirectory(s:plug)
    echo 'install vim-plug...'
    call system('mkdir -p ' . s:load_dir)
    call system('mkdir -p ' . s:plug_dir)
    call system('curl -fLo ' . s:plug . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
  end
  execute 'set runtimepath+=' . s:plug
endif

" vim-plugによるplugin管理
" 使い方
" :PlugInstall
" :PlugStatus
call plug#begin(s:plug_dir)
  Plug 'morhetz/gruvbox'                " color schema
  Plug 'Yggdroot/indentLine'            " インデントを可視化
  Plug 'rhysd/accelerated-jk'           " j, k移動高速化
  Plug 'easymotion/vim-easymotion'      " カーソル移動高速化
  Plug 'airblade/vim-gitgutter'         " gitの変更箇所を左にマーク表示する
  Plug 'tpope/vim-rhubarb'              " fugitiveのGbrowseでブラウザGitHub開く用に
  Plug 'tpope/vim-fugitive'             " Git関連使いやすいように
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'cohama/lexima.vim'              " rubyとかvimscriptのifとかの終了を補完してくれる
  Plug 'sheerun/vim-polyglot'           " いろんなもののハイライト
  Plug 'w0rp/ale'                       " いろんなLinterを実行
  Plug 'tpope/vim-commentary'           " コメントの切り替えをgccでできるようになる
  Plug 'tpope/vim-surround'             " 選択文字をSで囲んだり、囲み文字切り替えできるようになる

  Plug 'mechatroner/rainbow_csv',     { 'for': 'csv' }
  Plug 'leafgarland/typescript-vim',  { 'for': 'typescript' }
  Plug 'mattn/emmet-vim',             { 'for': ['html', 'css', 'scss', 'vue'] }

  Plug 'ryanoasis/vim-devicons'         " ファイラーのアイコン表示
  Plug 'cocopon/vaffle.vim'             " ファイラー

  Plug 'junegunn/fzf',                { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'mattn/vim-lsp-settings'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/vim-vsnip-integ'
call plug#end()

"---------------------------------------------------------------
" 設定ファイルの読み込み
let s:plug_rc = 'source ' . $HOME . '/.config/nvim/plug/'
let s:load_rc   = {file -> execute(s:plug_rc . file . '.vim')}
call s:load_rc('plug')                " プラグインの読み込み
call s:load_rc('fugitive')            " fugitiveの設定読み込み
call s:load_rc('vaffle')              " ファイラーの設定読み込み
call s:load_rc('fzf')                 " fzfの設定読み込み
call s:load_rc('lsp')                 " lspの設定読み込み

