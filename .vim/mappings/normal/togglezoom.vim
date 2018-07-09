""
" Toggle zoom current buffer in the new tab.
"
" nnoremap <silent> gz :call mappings#normal#togglezoom#()<Enter>
""
function! mappings#normal#togglezoom#() abort
	if winnr('$') > 1
		tab split
	elseif
		\ len(
			\ filter(
				\ map(
					\ range(tabpagenr('$')),
					\ 'tabpagebuflist(v:val + 1)'
				\ ),
				\ printf('index(v:val, %s) >= 0', bufnr(''))
			\ )
		\ ) > 1
		tabclose
	endif
endfunction
