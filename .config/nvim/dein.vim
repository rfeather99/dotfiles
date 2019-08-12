scriptencoding utf-8

"**************************
" プラグインマネージャの設定
"**************************
let s:dein_dir = expand('~/.cache/dein')

"deinの存在確認＆なければインストール
let s:dein = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein
  endif
  execute 'set runtimepath+=' . s:dein
endif

"deinの設定
if dein#load_state(s:dein_dir)
  let s:toml = [
        \ {'name': 'dein'},
        \ {'name': 'dein_lazy',   'lazy': 1},
        \ {'name': 'defx_lazy',   'lazy': 1},
        \ {'name': 'denite_lazy', 'lazy': 1},
        \ {'name': 'coc_lazy',    'lazy': 1},
        \ ]
  let s:path      = {name -> $HOME . '/.config/nvim/dein/' . name . '.toml'}
  let s:load_toml = {name, lazy -> dein#load_toml(s:path(name), {'lazy': lazy})}

  call dein#begin(s:dein_dir)
  call map(s:toml, {_, t -> s:load_toml(t['name'], get(t, 'lazy', 0))})

  "設定の保存
  call dein#end()
  call dein#save_state()
endif

"未インストールのpluginをダウンロード
if dein#check_install()
  call dein#install()
endif

