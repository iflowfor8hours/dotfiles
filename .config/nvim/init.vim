"===================================[ config ]==================================
let g:vim_config = $HOME . "/.config/nvim/"

let s:modules = [
	\"settings",
	\"mappings",
	\"plugins",
	\]

for s:module in s:modules
	execute "source" g:vim_config . s:module . ".vim"
endfor

"============================[ local configuration ]============================
let s:local_vimrc = expand("~/.vimrc_local")
if filereadable(s:local_vimrc)
	execute 'source' s:local_vimrc
endif

"===============================================================================
"==================================[ testing ]==================================
"===============================================================================
" lookup whichwrap
" make h/l move across beginning/end of line
" set whichwrap+=hl

" Close quickfix & help with q, Escape, or Control-C
" Also, keep default <cr> binding
augroup easy_close
	autocmd!
	autocmd FileType help,qf nnoremap <buffer> q :q<cr>
	autocmd FileType help,qf nnoremap <buffer> <Esc> :q<cr>
	autocmd FileType help,qf nnoremap <buffer> <C-c> :q<cr>
	" Undo <cr> -> : shortcut
	" autocmd FileType help,qf nnoremap <buffer> <cr> <cr>
augroup END

" nnoremap <leader>w :w<cr>
nnoremap <leader>w :echoerr "stop it you have autosave"<cr>
" cabbrev w echoerr "stop it you have autosave"

" when would I want to reindent a line with ^F _after_ '!'? bizzare.
" delete until the end of word
inoremap <c-f> <c-\><c-o>de

" switch panes
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

"================================[ command mode ]===============================
" make start of line and end of line movements match zsh/bash
cnoremap <c-a> <home>
cnoremap <c-e> <end>

" Move by word
cnoremap <m-b> <s-left>
cnoremap <m-f> <s-right>

" make commandline history smarter (use text entered so far)
cnoremap <c-n> <down>
cnoremap <c-p> <up>

"==================================[ terminal ]=================================
" I like to get out with one key
tnoremap <esc> <c-\><c-n>
tnoremap <c-[> <c-\><c-n>

" consistent window movement commands
tnoremap <c-h> <c-\><c-n><c-w>h
tnoremap <c-j> <c-\><c-n><c-w>j
tnoremap <c-k> <c-\><c-n><c-w>k
tnoremap <c-l> <c-\><c-n><c-w>l
