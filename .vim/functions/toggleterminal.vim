""
" Toggle terminal buffer or create new one if there is none.
"
" nnoremap <silent> <C-z> :call mappings#normal#toggleterminal#()<Enter>
" tnoremap <silent> <C-z> <C-\><C-n>:call mappings#normal#toggleterminal#()<Enter>
""
function! toggleterminal#() abort
	if !has('nvim')
		return v:false
	endif

	" Create the terminal buffer.
	if !exists('g:terminal') || !g:terminal.term.loaded
		return terminal#create()
	endif

	" Go back to origin buffer if current buffer is terminal.
	if g:terminal.term.bufferid ==# bufnr('')
		silent execute 'buffer' g:terminal.origin.bufferid

	" Launch terminal buffer and start insert mode.
	else
		let g:terminal.origin.bufferid = bufnr('')

		silent execute 'buffer' g:terminal.term.bufferid
		startinsert
	endif
endfunction
