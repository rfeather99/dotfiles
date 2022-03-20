if empty(globpath(&rtp, 'autoload/fugitive.vim'))
  finish
endif

function! s:ToggleGStatus() abort
    if buflisted(bufname('.git/index'))
        bd .git/index
    else
        Git
    endif
endfunction

set diffopt+=vertical
:command S call s:ToggleGStatus()
:command Gs call s:ToggleGStatus()
:command Ga Gwrite
:command Gc Git commit
:command Gd Gdiff
:command Gm Gmerge
:command Gb Git blame
:command Gh Gbrowse

