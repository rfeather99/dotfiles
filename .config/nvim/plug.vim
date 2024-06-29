scriptencoding utf-8

"**************************
" プラグインマネージャの設定
"**************************
let s:load_dir = expand('~/.local/share/nvim/site/autoload')
let s:plug_dir = expand('~/.local/share/nvim/site/plugged')

" Vimを開いた時にvim-plugを用意する
let s:plug = s:load_dir . '/plug.vim'
if has('vim_starting')
  if empty(glob(s:plug))
    echo 'install vim-plug...'
    call system('mkdir -p ' . s:load_dir)
    call system('mkdir -p ' . s:plug_dir)
    call system('curl -fLo ' . s:plug . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
  execute 'set runtimepath+=' . s:plug
endif

" vim-plugによるplugin管理
" 使い方
" :PlugInstall
" :PlugStatus
call plug#begin(s:plug_dir)
  Plug 'ellisonleao/gruvbox.nvim'             " color schema
  Plug 'folke/tokyonight.nvim'                " color schema
  Plug 'lukas-reineke/indent-blankline.nvim'  " インデントを可視化
  Plug 'rhysd/accelerated-jk'                 " j, k移動高速化
  Plug 'easymotion/vim-easymotion'            " カーソル移動高速化
  Plug 'airblade/vim-gitgutter'               " gitの変更箇所を左にマーク表示する
  Plug 'tpope/vim-rhubarb'                    " fugitiveのGbrowseでブラウザGitHub開く用に
  Plug 'tpope/vim-fugitive'                   " Git関連使いやすいように
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'cohama/lexima.vim'                    " rubyとかvimscriptのifとかの終了を補完してくれる
  Plug 'tpope/vim-commentary'                 " コメントの切り替えをgccでできるようになる
  Plug 'tpope/vim-surround'                   " 選択文字をSで囲んだり、囲み文字切り替えできるようになる

  Plug 'mechatroner/rainbow_csv',     { 'for': 'csv' }
  Plug 'mattn/emmet-vim',             { 'for': ['html', 'css', 'scss', 'vue', 'eruby'] }
  Plug 'previm/previm',               { 'for': 'markdown' }

  Plug 'lambdalisue/fern.vim'
  "Plug 'lambdalisue/fern-git-status.vim'
  Plug 'lambdalisue/nerdfont.vim'       " ファイラーのアイコン表示
  Plug 'lambdalisue/fern-renderer-nerdfont.vim'
  Plug 'lambdalisue/glyph-palette.vim'  " アイコンカラー設定

  " highlight
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

  " telescope
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

  Plug 'stevearc/aerial.nvim'

  " lsp
  Plug 'neovim/nvim-lspconfig'
  Plug 'williamboman/mason.nvim'
  Plug 'williamboman/mason-lspconfig.nvim'
  Plug 'nvimtools/none-ls.nvim'

  " Java
  Plug 'mfussenegger/nvim-jdtls'

  " dap
  Plug 'mfussenegger/nvim-dap'
  Plug 'theHamsta/nvim-dap-virtual-text'
  Plug 'rcarriga/nvim-dap-ui'
  Plug 'nvim-neotest/nvim-nio'

  " test runner
  Plug 'vim-test/vim-test'

  " completion
  Plug 'onsails/lspkind-nvim'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-cmdline'

  Plug 'github/copilot.vim'

  " diagnostics
  Plug 'folke/trouble.nvim'

call plug#end()

"---------------------------------------------------------------
" 設定ファイルの読み込み
let s:plug_rc = 'source ' . $HOME . '/.config/nvim/plug/'
let s:load_rc   = {file -> execute(s:plug_rc . file . '.vim')}
runtime plug/plug.vim                " プラグインの読み込み
call s:load_rc('fugitive')            " fugitiveの設定読み込み
call s:load_rc('fern')                " ファイラーの設定読み込み
call s:load_rc('treesitter')          " treesitterの設定読み込み
runtime plug/telescope.lua
runtime plug/lsp.lua
runtime plug/dap.lua
runtime plug/test.lua

" colorschemeの設定
colorscheme gruvbox
"" 背景透過を有効化
hi Normal guibg=NONE ctermbg=NONE
hi NonText guibg=NONE ctermbg=NONE
