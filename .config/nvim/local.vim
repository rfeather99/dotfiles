" .vmirc.local
" サンプル
" " change test executable with docker
" let test#java#maventest#executable = "docker exec -t xxxx-java ./mvnw"
" let test#ruby#rspec#executable = "docker exec -t xxxx-ruby bin/rspec"


" Load settings for each location.
function! s:vimrc_local(loc)
  let files = findfile('.vimrc.local', escape(a:loc, ' ') . ';', -1)
  for i in reverse(filter(files, 'filereadable(v:val)'))
    source `=i`
  endfor
endfunction
call s:vimrc_local(expand('<afile>:p:h'))

