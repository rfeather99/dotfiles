# dotfiles
my dotfiles

# 前提のプログラム
zsh,vimは元々入っているけど、最新取得  
* zsh zsh-completionsa
* tmux
* neovim
* cicaフォント
  ホスト側に入れて、defxとかでアイコン表示できるようにする

# nvim
deocompeteのために以下をインストール

## neovim
`pip3 instal --upgrade neovim`

## 主要なプラグイン
- fugitive
- dein
- defx

## よく使うキー

### デフォルト

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


