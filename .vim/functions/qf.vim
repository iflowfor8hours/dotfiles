""
" QuickFix custom foldtext expression.
"
" setlocal foldexpr=qf#foldexpr()
""
function! qf#foldtext() abort
	let l:lines = v:foldend - v:foldstart + 1
	let l:file = substitute(getline(v:foldstart), '\v\c\|.+', '', '')

	return printf('%s [%s]', l:file, l:lines)
endfunction

""
" QuickFix custom fold expression.
"
" setlocal foldtext=qf#foldtext(v:lnum)
"
" @param {number} lnum Line number for the 'foldexpr'.
""
function! qf#foldexpr(lnum) abort
	if matchstr(getline(a:lnum), '\v\c^[^|]+') ==# matchstr(getline(a:lnum + 1), '\v\c^[^|]+')
		return 1
	else
		return '<1'
	endif
endfunction
