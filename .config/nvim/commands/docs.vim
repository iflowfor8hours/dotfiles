""
" Open documentations in browser for given query.
"
" command -nargs=* Docs call commands#docs#(<q-args>)
"
" @param {string} query Search query for documentation.
""
function! commands#docs#(query) abort
	call system(
		\ printf(
			\ '%s "https://devdocs.io/?q=%s"',
			\ executable('reopen') ? 'reopen' : 'xdg-open',
			\ a:query
		\ )
	\ )
endfunction
