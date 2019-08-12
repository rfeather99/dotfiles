# dotfiles
my dotfiles

# 前提のプログラム
zsh,vimは元々入っているけど、最新取得  
* zsh zsh-completionsa
* tmux
* neovim
* cicaフォント

    ホスト側に入れて、defxとかでアイコン表示できるようにする
* ag

    deniteでの絞り込み用

# nvim
## 初回だけ実行
- 色々なプラグインのために以下をインストール

  `pip3 instal --upgrade neovim`

- Cocのインストール

  1. プラグインインストールようのディレクトリを作成しておく

    `mkdir -p ~/.config/coc/extensions`

  2. vim起動後に実行
    
    `:call coc#util#install()`

## 主要なプラグイン
- fugitive
- dein
- defx
- denite
- coc

## よく使うキー

### デフォルト

モード | キー | 内容
--- | --- | ---
n | ctrl+o | カーソル移動履歴を戻る
n | ctrl+i | カーソル移動履歴を進む

### カスタム

モード | キー | 内容
--- | --- | ---
i | jj | ESCと同じ


### TAB関連

キー | 内容
--- | ---
tc | 新しいTABを開く
t1 | TAB 1に移動
t2 | TAB 2に移動
t3 | TAB 3に移動
t4 | TAB 4に移動
t5 | TAB 5に移動
t6 | TAB 6に移動
t7 | TAB 6に移動
t8 | TAB 8に移動
t9 | TAB 9に移動
tn | 次のTABに移動
tc | 前のTABに移動

### fugitive関連

コマンド | 内容
--- | ---
:Gs | :Gstatusビューを表示する


- Gstatusビューでの操作

  キー | 内容
  --- | ---
  D | diffを表示
  `-` | stageとworkの切り替え

### Defx関連

モード | キー | 内容
--- | --- | ---
n | Ctrl + n | ファイラーを開く


- ファイラーでの操作

  キー | 内容
  --- | ---
  ~ | `home`に移動
  h | 1つ上のフォルダに移動
  N | 新規ファイル作成

### Denite関連

キー | 内容
--- | ---
zf | `:Denite file/rec`起動
zb | `:Denite buffer`起動
zl | `:Denite line`起動
zy | `:Denite neoyank`起動
  
- 起動中のコマンド

  キー | 内容
  --- | ---
  i | フィルタ起動
  q | `:Denite`終了
  p | プレビュー表示

### Coc関連

キー | 内容
--- | ---
gd | `coc-definition`を起動
gi | `coc-implementation`を起動
gr | `coc-references`を起動
gy | `coc-type-definition`を起動
 

