" Vim filetype plugin file
" Language:	Bazaar-NG (bzr) commit file
" Maintainer:	Adeodato Simó <dato@net.com.org.es>
" BranchURL:	http://people.debian.org/~adeodato/code/bzr/bzr-vim

" Description:
" This plugin provides the following functionality:
"   - options to have completion search inside files being commited
"     (handy eg. to complete class or method names).
"   - a function to insert the diff of the files being commited into the
"     file. It is accessible via ":Diff", and also with "<LocalLeader>d".
"     The <Ctrl-]> key binding, normally used to jump to tags, is mapped
"     to invoking the function with the file under the cursor as argument.

" Variables:
" You may set the following variables in your ~/.vimrc:
"   - bzr_command: name (or full path) of the bzr executable (default: bzr).
"   - bzrlog_auto_diff: if set, the commit diff is automatically
"                       inserted when opening the file.
"   - no_bzrlog_maps (or no_plugin_maps): disable the mappings.

if exists('b:did_ftplugin')
    finish
endif
let b:did_ftplugin = 1

if exists('g:bzr_command')
    let s:bzr_command = g:bzr_command
else
    let s:bzr_command = 'bzr'
endif

" Options:
" Make completion search in commited files
setlocal include=^\ \ \\zs.*[^/]$

" Path:
let b:bzr_root = getcwd()
while ! isdirectory(b:bzr_root . '/.bzr')
    let b:bzr_root = substitute(b:bzr_root, '/[^/]\+/\?$', '', '')
endw
let &l:path = b:bzr_root . &l:path

" Commands:
command -buffer -nargs=* -complete=file Diff call <SID>InsertDiff(<f-args>)

" Mappings:
if !exists("no_plugin_maps") && !exists("no_bzrlog_maps")
    if !hasmapto('<Plug>InsertDiff')
    	map <buffer> <unique> <LocalLeader>d <Plug>InsertDiff
    endif
    noremap <buffer> <unique> <Plug>InsertDiff :call <SID>InsertDiff()<CR>

    if !hasmapto('<Plug>InsertFileDiff')
    	map <buffer> <unique> <C-]> <Plug>InsertFileDiff
    endif
    noremap <buffer> <unique> <Plug>InsertFileDiff :call <SID>InsertFileDiff()<CR>
endif

" Functions:
if !exists("*s:CommitFiles")
    function s:CommitFiles()
    	let files = ''
    	call cursor(1, 1)
	call search('^-\{10,} .* -\{10,}$')
	while 1
	    if search('^\(added\|removed\|modified\):$', 'W')
	    	let i = 1
		let l = line(".")
	    	while 1
		    let line = getline(i+l)
		    if match(line, '  ', 0) != 0
		    	break
		    endif
	    	    let files = files . line
		    let i = i+1
		endw
	    else
	    	break
	    endif
	endw
	return files
    endf
endif

if !exists("*s:InsertFileDiff")
    function s:InsertFileDiff()
    	normal yaW
	call <SID>InsertDiff(getreg('"'))
    endf
end

if !exists("*s:InsertDiff")
    function s:InsertDiff(...)
	if a:0 > 0
	    " no a:000 to be vim6-compatible
	    let i = 1
    	    let args = ''
	    while i <= a:0
	    	let args = args . ' ' . escape(a:{i}, ' ')
	    	let i = i+1
	    endw
	else
	    let args = s:CommitFiles()
	endif

	let l = line('$')
	call append(l, '# start diff')
	call append(l, '')
	call cursor(l+2, 1)
	exe 'read! cd "'.b:bzr_root.'"; env BZR_PROGRESS_BAR=none '.s:bzr_command.' diff '.args
	call cursor(l+1, 1)
    endf
endif

if exists('g:bzrlog_auto_diff')
    call <SID>InsertDiff()
endif

" Undo:
let b:undo_ftplugin = "setlocal path< include< iskeyword<"
    \ . "| unlet b:bzr_root"
    \ . "| delcommand Diff"
