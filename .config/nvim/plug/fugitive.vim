if empty(globpath(&rtp, 'autoload/fugitive.vim'))
  finish
endif

function! s:ToggleGStatus() abort
    if buflisted(bufname('.git/index'))
        bd .git/index
    else
        Gstatus
    endif
endfunction

set diffopt+=vertical
:command S call s:ToggleGStatus()
:command Gs call s:ToggleGStatus()
:command Ga Gwrite
:command Gc Gcommit-v
:command Gd Gdiff
:command Gm Gmerge
:command Gb Gblame
:command Gh Gbrowse

