" 1に設定すると、Markdownバッファを開いたときにプレビューウィンドウを自動で開きます。
" デフォルト: 0
let g:mkdp_auto_start = 0

" 1に設定すると、Markdownバッファから他のバッファに切り替えたときに
" 現在のプレビューウィンドウを自動で閉じます。
" デフォルト: 1
let g:mkdp_auto_close = 0

" 1に設定すると、バッファを保存したり挿入モードを終了したときにMarkdownをリフレッシュします。
" デフォルトの0は、編集やカーソル移動中にMarkdownを自動リフレッシュします。
" デフォルト: 0
let g:mkdp_refresh_slow = 0

" 1に設定すると、Markdownファイル以外でもMarkdownPreviewコマンドが使用可能になります。
" デフォルト: 0
let g:mkdp_command_for_global = 0

" 1に設定すると、プレビューサーバーがネットワーク内の他のユーザーにも利用可能になります。
" デフォルトでは、サーバーはlocalhost (127.0.0.1) でリッスンします。
" デフォルト: 0
let g:mkdp_open_to_the_world = 0

" プレビューを開く際に使用するカスタムIPを指定します。
" リモートVimを使用してローカルブラウザでプレビューする際に便利です。
" 詳細は https://github.com/iamcco/markdown-preview.nvim/pull/9 を参照してください。
" デフォルト: 空
let g:mkdp_open_ip = ''

" プレビューを開くブラウザを指定します。
" パスにスペースがある場合の形式:
" 有効: `/path/with\ space/xxx`
" 無効: `/path/with\\ space/xxx`
" デフォルト: ''
let g:mkdp_browser = ''

" 1に設定すると、プレビューを開く際にURLをコマンドラインに表示します。
" デフォルトは0
let g:mkdp_echo_preview_url = 0

" プレビューを開くためのカスタムVim関数名を指定します。
" この関数にはURLが引数として渡されます。
" デフォルト: 空
let g:mkdp_browserfunc = ''

" Markdownレンダリング用のオプション
" mkit: markdown-it のオプション
" katex: 数式用のKaTeXオプション
" uml: markdown-it-plantuml のオプション
" maid: mermaid のオプション
" disable_sync_scroll: 同期スクロールを無効にするかどうか、デフォルトは0
" sync_scroll_type: 'middle', 'top' または 'relative' (デフォルト: 'middle')
"   middle: カーソル位置が常にプレビューページの中央
"   top: Vimの表示上部がプレビューページの上部に対応
"   relative: カーソル位置がプレビューページの相対位置
" hide_yaml_meta: YAMLメタデータを非表示にするか、デフォルトは1
" sequence_diagrams: js-sequence-diagrams のオプション
" content_editable: プレビューページを編集可能にするか、デフォルト: v:false
" disable_filename: プレビューページでファイル名ヘッダーを非表示にするか、デフォルト: 0
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ 'disable_filename': 0,
    \ 'toc': {}
    \ }

" カスタムMarkdownスタイルを使用します。
" 絶対パスで指定する必要があります。
" 例: '/Users/username/markdown.css' または expand('~/markdown.css')
let g:mkdp_markdown_css = ''

" カスタムハイライトスタイルを使用します。
" 絶対パスで指定する必要があります。
" 例: '/Users/username/highlight.css' または expand('~/highlight.css')
let g:mkdp_highlight_css = ''

" サーバー起動時に使用するカスタムポートを指定します。
" 空の場合はランダムに選択されます。
let g:mkdp_port = ''

" プレビューページのタイトル
" ${name} はファイル名に置き換えられます。
let g:mkdp_page_title = '「${name}」'

" 画像の保存場所をカスタマイズします。
let g:mkdp_images_path = expand('$HOME/.markdown_images')

" 対応するファイルタイプ
" これらのファイルタイプでMarkdownPreviewコマンドが利用可能です。
let g:mkdp_filetypes = ['markdown']

" デフォルトテーマ (dark または light) を設定します。
" デフォルトではシステムの設定に基づいてテーマが選択されます。
let g:mkdp_theme = 'light'

" プレビューウィンドウを再利用します。
" デフォルト: 0
" 有効にすると、Markdownファイルをプレビューするときに前回開いたプレビューウィンドウを再利用します。
" このオプションを有効にする場合、let g:mkdp_auto_close = 0 を設定してください。
let g:mkdp_combine_preview = 1

" Markdownバッファを変更したときにプレビュー内容を自動更新します。
" g:mkdp_combine_preview が1の場合のみ有効です。
let g:mkdp_combine_preview_auto_refresh = 1
