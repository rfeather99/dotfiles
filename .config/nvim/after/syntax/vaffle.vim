let g:sol = {
  \"cterm": {
    \"base03": 8,
    \"base02": 0,
    \"base01": 10,
    \"base00": 11,
    \"base0": 12,
    \"base1": 14,
    \"base2": 7,
    \"base3": 15,
    \"grey": 240,
    \"yellow": 3,
    \"orange": 9,
    \"red": 1,
    \"magenta": 5,
    \"violet": 13,
    \"blue": 4,
    \"cyan": 6,
    \"green": 2
  \}
\}

function! DeviconsColors(config)
  let colors = keys(a:config)
  augroup devicons_colors
    autocmd!
    for color in colors
      if color == 'normal'
        exec 'autocmd FileType vaffle if &background == ''dark'' | '.
          \ 'highlight devicons_'.color.' ctermfg='.g:sol.cterm.base01.' | '.
          \ 'else | '.
          \ 'highlight devicons_'.color.' ctermfg='.g:sol.cterm.base1.' | '.
          \ 'endif'
      else
        exec 'highlight devicons_'.color.' ctermfg='.g:sol.cterm[color]
      endif
      exec 'syntax match devicons_'.color.' /\v'.join(a:config[color], '|').'/ containedin=ALL'
    endfor
  augroup END
endfunction

let g:devicons_colors = {
  \'normal': ['', ''],
  \'grey': ['', '', '', '', '', '', '', '', ''],
  \'yellow': ['', '', '', '', '', '', ''],
  \'orange': ['', '', '', 'λ', '', ''],
  \'red': ['', '', '', '', '', '', '', '', ''],
  \'magenta': [''],
  \'violet': ['', '', '', ''],
  \'blue': ['', '', '', '', '', '', '', '', '', '', '', '', '', '', ''],
  \'cyan': ['', '', '', ''],
  \'green': ['', '', '', '', '']
\}
call DeviconsColors(g:devicons_colors)

