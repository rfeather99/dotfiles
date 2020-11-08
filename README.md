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

    fzfでの絞り込み用

# tmux

## プレフィックスキー
 - ctrl + j

## よくつかうキー

キー | 内容
--- | ---
h,j,k,l | ペインを移動
H,J,K,L | ペインをリサイズ
Ctrl + h | 左のウィンドウに移動
Ctrl + l | 右のウィンドウに移動
{ | 左のペインと位置を入れ替え
} | 右のペインと位置を入れ替え
z | ペインを最大表示
option + 1 | horizontal to verticalレイアウト
option + 2 | vertical to horizontalレイアウト
:set-window-option synchronize-panes on | 全pane一斉入力

## よくつかうキー(プレフィックスキー不要 -n)

キー | 内容
--- | ---
shift + LeftKey | ペインを左のウィンドウに移動する
shift + RightKey | ペインを右のウィンドウに移動する
shift + DownKey | ペインを新しいウィンドウに移動する

# nvim
## 初回だけ実行
- 色々なプラグインのために以下をインストール

  `pip3 instal --upgrade neovim`

## 主要なプラグイン
- fugitive
- dein
- vim-lsp
- fzf
- fern

## よく使うキー

### デフォルト

モード | キー | 内容
--- | --- | ---
i | ctrl+c | insertモード終了(ESCと同じ)
v | ctrl+c | visualモード終了(ESCと同じ)
c | ctrl+c | commandモード終了(ESCと同じ)
n | ctrl+o | カーソル移動履歴を戻る
n | ctrl+i | カーソル移動履歴を進む
n | * | カーソル一にある単語を検索
n | ~ | 大文字小文字変換
n | \< | インデント上げ
n | \> | インデント下げ
v | \< | 複数行インデント上げ
v | \> | 複数行インデント下げ
c/i | ctrl+r 0 | 貼り付け

### カスタム

モード | キー | 内容
--- | --- | ---
i | jj | ESCと同じ
n | \<Space\>o | 新規バッファ表示
n | \<Space\>w | :wと同じ
n | \<Space\>q | :qと同じ
n | \<Space\>\<Space\> | ヴィジュアルラインモード起動
n | # | /検索した結果を置換

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

### easymotion関連

モード | キー | 内容
--- | --- | ---
n | s{char}{char}{hint} | hintの位置に移動

### fugitive関連

コマンド | 内容
--- | ---
:Gs | :Gstatusビューを表示する
:Gc | git commit
:Gb | blameを表示. qで終了
:Gbrowse | ブラウザでgithubを表示. visualモード時は選択行ハイライト

- Gstatusビューでの操作

  キー | 内容
  --- | ---
  dd | diffを表示
  `-` | stageとworkの切り替え
  X | revert change
  q | 終了

### fern関連

モード | キー | 内容
--- | --- | ---
n | Ctrl + e | ファイラーを開く


- ファイラーでの操作
  ファイルのコピーはできない

  キー | 内容
  --- | ---
  h,j,k,l | フォルダ階層の移動
  N | 新規ファイル作成
  K | 新規ディレクトリ作成
  D | ファイル・ディレクトリの削除
  m | ファイルの移動
  c | ファイルのコピー
  R | ファイルのリネーム
  x | システムで開く

### fzf関連

キー | 内容
--- | ---
zf | ファイル検索
zb | バッファー検索
zd | バッファー削除
zl | 表示しているバッファー内の行検索
zg | grep

- 起動中のコマンド

  キー | 内容
  --- | ---
  ctrl-n | 次の候補に移動
  ctrl-p | 前の候補に移動
  ctrl-f | ページ送り
  ctrl-b | ページ戻り
  ctrl-c | fzf終了

### vim-lsp関連

キー | 内容
--- | ---
gd | `lsp-definition`を起動
gi | `lsp-implementation`を起動
gr | `lsp-references`を起動
gh | `lsp-hover`を起動

### commentary関連

モード | キー | 内容
--- | --- | ---
n | gcc | 行をコメントのオンオフ
v | gc | 選択行をコメントのオンオフ

### surround関連

モード | キー | 内容
--- | --- | ---
v | S{囲み文字} | 囲み文字で選択範囲を囲む
n | cs{囲み文字}{新しい囲み文字} | 囲み文字を替える
n | ds{囲み文字} | 囲み文字を削除する

### emmet関連

モード | キー | 内容
--- | --- | ---
n | \<crtl-y\>, | emmetを展開する

### RainbowCSV関連

キー | 内容
--- | ---
F5 | RBQLを起動
F5 | RBQLを実行

