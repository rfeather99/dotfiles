" .vmirc.local
" サンプル
"
" let g:ale_fix_on_save = 0
" let g:lsp_diagnostics_virtual_text_enabled = 0
"

" let s:solargraph_port = 0
" let s:solargraph_docker_id = ""

" function! s:setup_solargraph() abort
"   if s:solargraph_port > 0
"     return
"   endif

"   let s:solargraph_port = 7658
"   let l:result =  system("lsof -i:".s:solargraph_port)
"   while len(l:result) > 0
"     let s:solargraph_port = s:solargraph_port + 1
"     let l:result =  system("lsof -i:".s:solargraph_port)
"   endwhile

"   let s:solargraph_docker_id = system("docker run -d --rm -p ".s:solargraph_port.":7658 -v $PWD:/usr/src/app --health-cmd 'ps aux | grep port=7658 | grep -vc grep || exit 1' --health-interval=1s --health-timeout=1s --health-retries=10 xxxxx/xxxxxx bash -c \"mkdir -p `dirname $PWD` && ln -snf /usr/src/app $PWD && solargraph socket --host=0.0.0.0 --port=7658\"")
"   let l:health = system("docker inspect -f '{{if eq \"healthy\" .State.Health.Status}}0{{else}}1{{end}}' ".s:solargraph_docker_id)
"   while l:health == 1
"     sleep 1
"     let l:health = system("docker inspect -f '{{if eq \"healthy\" .State.Health.Status}}0{{else}}1{{end}}' ".s:solargraph_docker_id)
"   endwhile

"   call lsp#register_server({
"     \    'name': 'solargraph',
"     \    'cmd': {server_info->['nc', '127.0.0.1', s:solargraph_port]},
"     \    'allowlist': ['ruby'],
"     \    'initialization_options': {
"             \ "logLevel": "debug",
"             \ "diagnostics": v:true,
"           \},
"     \})
" endfunction

" function! s:shutdown_solargraph() abort
"   if len(s:solargraph_docker_id) == 0
"     return
"   endif

"   let l:result = system("docker stop ".s:solargraph_docker_id)
" endfunction

" augroup solargraph_setup
"   au!
"   autocmd User lsp_setup call s:setup_solargraph()
"   autocmd ExitPre * call s:shutdown_solargraph()
" augroup END

" augroup vimlsp_autoformat
"   au!
"   autocmd BufWritePre *.rb,*.feature LspDocumentFormatSync
" augroup END
"
"
" Load settings for each location.
function! s:vimrc_local(loc)
  let files = findfile('.vimrc.local', escape(a:loc, ' ') . ';', -1)
  for i in reverse(filter(files, 'filereadable(v:val)'))
    source `=i`
  endfor
endfunction
call s:vimrc_local(expand('<afile>:p:h'))

