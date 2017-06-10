"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Open and close the NERDTree
map <F4> :NERDTreeToggle<CR>
map <F5> :NERDTreeClose<CR>
map <F1> <Esc>
imap <F1> <Esc>
let NERDTreeWinPos="left"
let NERDTreeWinSize=20
" fold the numbers column
map <F2> :set invnumber<CR>
map <F3> call ToggleErrors()<CR>
set encoding=utf-8

call pathogen#infect() 

" Map space to / (search) and c-space to ? (backgwards search)
map <space> /
map <c-space> ?
map <LocalLeader><cr> :noh<cr>

" Smart way to move btw. windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
noremap <C-n> :tabnext<CR>                                            
noremap <C-p> :tabprev<CR>
set guicursor=a:block-blinkoff1

" Use the arrows to something usefull
map <right> :bnext!<cr>
map <left> :bprevious!<cr>
map <C-D> :bd<cr>

" operational settings
syntax on
set modeline
set scrolloff=8
set ruler                     " show the line number on the bar
set autoread                  " watch for file changes
set noautowrite               " don't automagically write on :next
set nocompatible              " vim, not vi
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
set autoindent 
set nosmartindent    " auto/smart indent
set expandtab                 " expand tabs to spaces (except java, see autocmd below
set softtabstop=2
set smarttab                  " tab and backspace are smart
set tabstop=2                 " 4 spaces
set shiftwidth=2              " shift width
set backspace=indent,eol,start  " backspace over all kinds of things
set showfulltag               " show full completion tags
set noerrorbells              " no error bells please
set undolevels=500            " 500 undos
set complete=.,w,b,u,U,t,i,d  " do lots of scanning on tab completion
set ttyfast                   " we have a fast terminal
filetype on                   " Enable filetype detection
filetype indent on            " Enable filetype-specific indenting
filetype plugin on            " Enable filetype-specific plugins
let mapleader=','
let maplocalleader=','        " all my shortcuts start with ,
set whichwrap+=<,>,h,l        " backspaces and cursor keys wrap to
set visualbell t_vb=          " Disable ALL bells
set cursorline                " show the cursor line
"set list                      " show whitespace where I care"
set matchpairs+=<:>           " add < and > to match pairs
set shell=bash

"don't use the backup files or swap files, they are annoying to look at
set nobackup
set nowritebackup
set noswapfile
set ai
"set textwidth=79
set comments=b:#

augroup cline
    au!
    au WinLeave,InsertEnter * set nocursorline
    au WinEnter,InsertLeave * set cursorline
augroup END

" Save when losing focus
au FocusLost * :silent! wall

" Resize splits when the window is resized
au VimResized * :wincmd =

" jump to the beginning and end of functions

nnoremap [[ ?{<CR>w99[{
nnoremap ][ /}<CR>b99]}
nnoremap ]] j0[[%/{<CR>
nnoremap [] k$][%?}<CR>
nnoremap ; :

set dictionary=/usr/share/dict/words " more words!

if has("gui_running")
      colorscheme zenburn   
      let rdark_current_line=1  " highlight current line
      set background=dark
      set noantialias
      set guioptions-=T        " no toolbar
      set guifont=Source\ Code\ Pro\ 10
      set guioptions-=l        " no left scrollbar
      set guioptions-=L        " no left scrollbar
      set guioptions-=r        " no right scrollbar
      set guioptions-=R        " no right scrollbar
      set lines=40
      set columns=115
end

set t_Co=256 
colorscheme zenburn

" status line 
set laststatus=2
if has('statusline')
  function! SetStatusLineStyle()
    let &stl="%F%m%r%h%w\ [%{&ff}]\ [%Y]\ %P [%{SyntasticStatuslineFlag()}] [%#warningmsg]\ #%=[a=\%03.3b]\ [h=\%02.2B]\ [%l,%v]"
  endfunc

  call SetStatusLineStyle()

  if has('title')
    set titlestring=%t%(\ [%R%M]%)
  endif

endif

function! ToggleErrors()
    if empty(filter(tabpagebuflist(), 'getbufvar(v:val, "&buftype") is# "quickfix"'))
         " No location/quickfix list shown, open syntastic error location panel
         Errors
    else
        lclose
nnoremap <silent> <C-e> :<C-u>call ToggleErrors()<CR>
    endif
endfunction



" ---------------------------------------------------------------------------
"  searching
set incsearch                 " incremental search
set ignorecase                " search ignoring case
set smartcase                 " Ignore case when searching lowercase
set hlsearch                  " highlight the search
set showmatch                 " show matching bracket
set diffopt=filler,iwhite     " ignore all whitespace and sync

" ---------------------------------------------------------------------------
"  mouse stuffs
set mousehide                 " hide the mouse when typing
map <MouseMiddle> <esc>"*p
"set mouse=nvi

" ---------------------------------------------------------------------------
"  backup options
set viminfo=%100,'100,/100,h,\"500,:100,n~/.viminfo
set history=2000

" ---------------------------------------------------------------------------
" spelling checker, toggle with ,ss or F6
if v:version >= 700

      setlocal spell spelllang=en
      nmap <LocalLeader>ss :set spell!<CR>
      nmap <F6> :set spell!<CR>

endif
" default to no spelling
set nospell

"Shortcuts using <LocalLeader>
map <LocalLeader>sn ]s
map <LocalLeader>sp [s
map <LocalLeader>sa zg
map <LocalLeader>s? z=
" When I'm pretty sure that the first suggestion is correct
map <LocalLeader>s! 1z=

if v:version >= 700
let g:is_bash = 1
let g:sh_noisk = 1
let g:markdown_fenced_languages = ['ruby', 'html', 'javascript', 'css', 'erb=eruby.html', 'bash=sh', 'sh']
let g:liquid_highlight_types = g:markdown_fenced_languages + ['jinja=liquid', 'html+erb=eruby.html', 'html+jinja=liquid.html']
let g:spellfile_URL = 'http://ftp.vim.org/vim/runtime/spell'
let g:CSApprox_verbose_level = 0
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
let g:ctrlp_working_path_mode = ''
let g:NERDTreeHijackNetrw = 0
let g:ragtag_global_maps = 1
let g:space_disable_select_mode = 1
let g:splitjoin_normalize_whitespace = 1
let g:VCSCommandDisableMappings = 1
let g:showmarks_enable = 0
let g:surround_{char2nr('-')} = "<% \r %>"
let g:surround_{char2nr('=')} = "<%= \r %>"
let g:surround_{char2nr('8')} = "/* \r */"
let g:surround_{char2nr('s')} = " \r"
let g:surround_{char2nr('^')} = "/^\r$/"
let g:surround_indent = 1

" some useful mappings
" Y yanks from cursor to $
map Y y$
" toggle paste mode
nmap <LocalLeader>pp :set paste!<cr>
" change directory to that of current file
nmap <LocalLeader>cd :cd%:p:h<cr>
" change local directory to that of current file
nmap <LocalLeader>lcd :lcd%:p:h<cr>
" correct type-o's on exit
nmap q: :q
" save and build
nmap <LocalLeader>wm  :w<cr>:make<cr>
" open all folds
nmap <LocalLeader>o  :%foldopen!<cr>
" close all folds
nmap <LocalLeader>c  :%foldclose!<cr>
" ,tt will toggle taglist on and off
nmap <LocalLeader>tt :Tlist<cr>
" q: sucks
nmap q: :q
" If I forgot to sudo vim a file, do that with :w!!
cmap w!! w !sudo tee %
" Fix the # at the start of the line
inoremap # X<BS>#
" When I forget I'm in Insert mode, how often do you type 'jj' anyway?
imap jj <Esc>
imap jk <Esc>
imap <Tab><Tab> <Esc>

" set list to activate whitespace detection mode
au BufNewFile,BufRead *.less set filetype=less
au BufRead,BufNewFile {Vagrantfile,Capfile,Gemfile,Rakefile,Thorfile,config.ru,.caprc,.irbrc,irb_tempfile*} set ft=ruby

" Wildmenu completion {{{
set wildmenu
set wildmode=list:longest

set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit
set wildignore+=*.luac                           " Lua byte code
set wildignore+=migrations                       " Django migrations
set wildignore+=*.pyc                            " Python byte code
set wildignore+=*.orig                           " Merge resolution files

" Command-T plugin
"
nmap <silent> <Leader>t <Plug>(CommandT)
nmap <silent> <Leader>b <Plug>(CommandTBuffer)
nmap <silent> <Leader>j <Plug>(CommandTJump)

" Format json
nmap <LocalLeader>js  :%!python -m json.tool<cr>

let g:pymode_rope_lookup_project = 0

" Don't fold please
set foldlevelstart=10
" disable folding
set nofoldenable
let g:vim_markdown_folding_disabled=1

set rtp+=~/.fzf

" Make sure Vim returns to the same line when you reopen a file.
augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END

command! -bang E e<bang>
command! -bang Q q<bang>
command! -bang W w<bang>
command! -bang QA qa<bang>
command! -bang Qa qa<bang>
command! -bang Wa wa<bang>
command! -bang WA wa<bang>
command! -bang Wq wq<bang>
command! -bang WQ wq<bang>

augroup ft_mail
    au!
    au Filetype mail setlocal spell
augroup END

" for scrolling up and down quickly
nnoremap J 7j
nnoremap K 7k
vnoremap J 7j
vnoremap K 7k

" Add syntastic warnings
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_loc_list_height = 5
let g:syntastic_check_on_wq = 0
let g:syntastic_shell = "/bin/zsh"

let g:syntastic_debug_file = "~/syntastic.log"

let g:syntastic_checkers_markdown = ['syntastic-markdown-proselint']
let g:syntastic_checkers_text = ['syntastic-text-proselint']
let g:syntastic_checkers_yaml = ['syntastic-yaml-yamllint']
let g:syntastic_checkers_zsh = ['syntastic-zsh-zsh']

"let g:syntastic_checkers_vim
"let g:syntastic_checkers_c
"let g:syntastic_checkers_cpp
"let g:syntastic_checkers_cmake
"let g:syntastic_checkers_dockerfile = [
"let g:syntastic_checkers_eruby
"let g:syntastic_checkers_go
"let g:syntastic_checkers_javascript
"let g:syntastic_checkers_json
"let g:syntastic_checkers_perl
"let g:syntastic_checkers_php
"let g:syntastic_checkers_python
"let g:syntastic_checkers_ruby
"let g:syntastic_checkers_sh
"let g:syntastic_checkers_sql

" Tpope craziness need to sort
augroup Misc " {{{2
    autocmd!

    autocmd FileType netrw call s:scratch_maps()
    autocmd FileType gitcommit if getline(1)[0] ==# '#' | call s:scratch_maps() | endif
    autocmd FocusLost   * silent! wall
    autocmd FocusGained * if !has('win32') | silent! call fugitive#reload_status() | endif
    autocmd SourcePre */macros/less.vim set laststatus=0 cmdheight=1
    autocmd User Fugitive
          \ if filereadable(fugitive#buffer().repo().dir('fugitive.vim')) |
          \   source `=fugitive#buffer().repo().dir('fugitive.vim')` |
          \ endif

    autocmd BufNewFile */init.d/*
          \ if filereadable("/etc/init.d/skeleton") |
          \   keepalt read /etc/init.d/skeleton |
          \   1delete_ |
          \ endif |
          \ set ft=sh

    autocmd BufReadPost * if getline(1) =~# '^#!' | let b:dispatch = getline(1)[2:-1] . ' %' | let b:start = b:dispatch | endif
    autocmd BufReadPost ~/.Xdefaults,~/.Xresources let b:dispatch = 'xrdb -load %'
    autocmd BufWritePre,FileWritePre /etc/* if &ft == "dns" |
          \ exe "normal msHmt" |
          \ exe "gl/^\\s*\\d\\+\\s*;\\s*Serial$/normal ^\<C-A>" |
          \ exe "normal g`tztg`s" |
          \ endif
  augroup END " }}}2
"  augroup FTCheck " {{{2
"    autocmd!
"    autocmd BufNewFile,BufRead *named.conf*       set ft=named
"    autocmd BufNewFile,BufRead *.txt,README,INSTALL,NEWS,TODO if &ft == ""|set ft=text|endif
"  augroup END " }}}2
"  augroup FTOptions " {{{2
"    autocmd!
"    autocmd FileType c,cpp,cs,java          setlocal commentstring=//\ %s
"    autocmd Syntax   javascript             setlocal isk+=$
"    autocmd FileType xml,xsd,xslt,javascript setlocal ts=2
"    autocmd FileType text,txt,mail          setlocal ai com=fb:*,fb:-,n:>
"    autocmd FileType sh,zsh,csh,tcsh        inoremap <silent> <buffer> <C-X>! #!/bin/<C-R>=&ft<CR>
"    autocmd FileType sh,zsh,csh,tcsh        let &l:path = substitute($PATH, ':', ',', 'g')
"    autocmd FileType perl,python,ruby       inoremap <silent> <buffer> <C-X>! #!/usr/bin/env<Space><C-R>=&ft<CR>
"    autocmd FileType c,cpp,cs,java,perl,javscript,php,aspperl,tex,css let b:surround_101 = "\r\n}"
"    autocmd FileType apache       setlocal commentstring=#\ %s
"    autocmd FileType cucumber let b:dispatch = 'cucumber %' | imap <buffer><expr> <Tab> pumvisible() ? "\<C-N>" : (CucumberComplete(1,'') >= 0 ? "\<C-X>\<C-O>" : (getline('.') =~ '\S' ? ' ' : "\<C-I>"))
"    autocmd FileType git,gitcommit setlocal foldmethod=syntax foldlevel=1
"    autocmd FileType gitcommit setlocal spell
"    autocmd FileType gitrebase nnoremap <buffer> S :Cycle<CR>
"    autocmd FileType help setlocal ai fo+=2n | silent! setlocal nospell
"    autocmd FileType help nnoremap <silent><buffer> q :q<CR>
"    autocmd FileType html setlocal iskeyword+=~ | let b:dispatch = ':OpenURL %'
"    autocmd FileType java let b:dispatch = 'javac %'
"    autocmd FileType lua  setlocal includeexpr=substitute(v:fname,'\\.','/','g').'.lua'
"    autocmd FileType perl let b:dispatch = 'perl -Wc %'
"    autocmd FileType ruby setlocal tw=79 comments=:#\  isfname+=:
"    autocmd FileType ruby
"          \ let b:start = executable('pry') ? 'pry -r "%:p"' : 'irb -r "%:p"' |
"          \ if expand('%') =~# '_test\.rb$' |
"          \   let b:dispatch = 'testrb %' |
"          \ elseif expand('%') =~# '_spec\.rb$' |
"          \   let b:dispatch = 'rspec %' |
"          \ elseif !exists('b:dispatch') |
"          \   let b:dispatch = 'ruby -wc %' |
"          \ endif
"    autocmd FileType liquid,markdown,text,txt setlocal tw=78 linebreak nolist
"    autocmd FileType tex let b:dispatch = 'latex -interaction=nonstopmode %' | setlocal formatoptions+=l
"          \ | let b:surround_{char2nr('x')} = "\\texttt{\r}"
"          \ | let b:surround_{char2nr('l')} = "\\\1identifier\1{\r}"
"          \ | let b:surround_{char2nr('e')} = "\\begin{\1environment\1}\n\r\n\\end{\1\1}"
"          \ | let b:surround_{char2nr('v')} = "\\verb|\r|"
"          \ | let b:surround_{char2nr('V')} = "\\begin{verbatim}\n\r\n\\end{verbatim}"
"    autocmd FileType vim  setlocal keywordprg=:help |
"          \ if exists(':Runtime') |
"          \   let b:dispatch = ':Runtime' |
"          \   let b:start = ':Runtime|PP' |
"          \ else |
"          \   let b:dispatch = ":unlet! g:loaded_{expand('%:t:r')}|source %" |
"          \ endif
    autocmd FileType timl let b:dispatch = ':w|source %' | let b:start = b:dispatch . '|TLrepl' | command! -bar -bang Console Wepl
    autocmd FileType * if exists("+omnifunc") && &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif
    autocmd FileType * if exists("+completefunc") && &completefunc == "" | setlocal completefunc=syntaxcomplete#Complete | endif
  augroup END "}}}2
endif " has("autocmd")
