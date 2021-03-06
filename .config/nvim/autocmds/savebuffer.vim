""
" Save the current buffer while keeping marks.
"
" autocmd InsertLeave,TextChanged * nested call autocmds#savebuffer#()
" autocmd FocusGained,BufEnter,CursorHold * silent! checktime
""
function! autocmds#savebuffer#() abort
	if empty(&buftype) && !empty(bufname(''))
		let l:savemarks = {
			\ "'[": getpos("'["),
			\ "']": getpos("']")
		\ }

		silent! update

		for [l:key, l:value] in items(l:savemarks)
			call setpos(l:key, l:value)
		endfor
	endif
endfunction
