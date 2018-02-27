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
"map <right> :bnext!<cr>
"map <left> :bprevious!<cr>
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
"set autoindent 
"set nosmartindent    " auto/smart indent
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
endif

set t_Co=256 
colorscheme zenburn

" status line 
set laststatus=2
if has('statusline')
  function! SetStatusLineStyle()
    let &stl="%F%m%r%h%w\ [%{&ff}]\ [%Y]\ %P [%#warningmsg]\ #%=[a=\%03.3b]\ [h=\%02.2B]\ [%l,%v]"
  endfunc

  call SetStatusLineStyle()

  if has('title')
    set titlestring=%t%(\ [%R%M]%)
  endif

endif

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
"set viminfo=%100,'100,/100,h,\"500,:100,n~/.viminfo
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

let g:is_bash = 1
let g:sh_noisk = 1
let g:spellfile_URL = 'http://ftp.vim.org/vim/runtime/spell'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:NERDTreeHijackNetrw = 1
let g:netrw_dirhistmax=0
let g:ragtag_global_maps = 1
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
" q: sucks
nmap q: :q
" If I forgot to sudo vim a file, do that with :w!!
cmap w!! w !sudo tee %
" Fix the # at the start of the line
"inoremap # X<BS>#
" When I forget I'm in Insert mode, how often do you type 'jj' anyway?
imap jj <Esc>
imap jk <Esc>
" imap <Tab><Tab> <Esc>

" set list to activate whitespace detection mode
au BufNewFile,BufRead *.less set filetype=less
au BufRead,BufNewFile {Vagrantfile,Capfile,Gemfile,Rakefile,Thorfile,config.ru,.caprc,.irbrc,irb_tempfile*} set ft=ruby
au BufRead,BufNewFile {*/*playbooks*/*.yml,*/*playbooks*/*.yaml,*/*roles*/*.yaml,*/*roles*/*.yml} set filetype=ansible
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType yml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType ansible setlocal ts=2 sts=2 sw=2 expandtab

" don't believe me just watch the config changes in .vimrc
augroup myvimrc
    au!
    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END


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

" Enable cursor line position tracking with ,c
:set cursorline
nmap <LocalLeader>c :set cursorline nocursorline!<CR>

let g:ansible_options = {'ignore_blank_lines': 0}
let g:ansible_options = {'documentation_mapping': '<C-K>'}

vmap <C-c> y:call SendViaOSC52(getreg('"'))<cr>
