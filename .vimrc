"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map <F1> <Esc>
map <F2> :set invnumber<CR>
map <F3> :ToggleWhitespace<CR>
map <F4> :Lexplore<CR>
map <F5> :GitGutterToggle<CR>

let g:netrw_winsize       = -28
let g:netrw_banner        = 0
let g:netrw_liststyle     = 3
let g:netrw_sort_sequence = '[\/]$,*'
let g:netrw_browse_split  = 4
let g:netrw_altv          = 1

set t_ut=
set termguicolors

"set t_8f=^[[38;2;%lu;%lu;%lum        " set foreground color
"set t_8b=^[[48;2;%lu;%lu;%lum        " set background color

colorscheme minimalist

" Map space to / (search) and c-space to ? (backgwards search)
map <space> /
map <c-space> ?

" Smart way to move btw. windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
noremap <C-n> :bn<CR>
noremap <C-p> :bp<CR>
"
" Use the arrows to something usefull
"map <right> :bnext!<cr>
"map <left> :bprevious!<cr>
map <C-D> :bd<cr>

"don't use the backup file or swap files, they are annoying to look at
"set autoindent
"set list                      "show whitespace where I care
"set nosmartindent    " auto/smart indent
"set textwidth=79
filetype plugin indent on            " Enable filetype-specific indenting
let mapleader=','
let maplocalleader=','        " all my shortcuts start with ,
set ai
"set autoread                  " watch for file changes
set backspace=indent,eol,start  " backspace over all kinds of things
set comments=b:#
set complete=.,w,b,u,U,t,i,d  " do lots of scanning on tab completion
set cursorline                " show the cursor line
set expandtab                 " expand tabs to spaces (except java, see autocmd below
"set listchars=tab:>-,trail:.,precedes:<,extends:>,eol:$
set listchars=tab:>-,trail:.,precedes:<,extends:>,eol:$
"set listchars=tab:\|\ ,trail:-,extends:>,precedes:<,nbsp:+
set matchpairs+=<:>           " add < and > to match pairs
set modeline
set noautowrite               " don't automagically write on :next
set nobackup
set nocompatible              " vim, not vi
set noswapfile
set nowritebackup
set ruler                     " show the line number on the bar
set scrolloff=8
set shell=bash
set shiftwidth=2              " shift width
set showfulltag               " show full completion tags
set smarttab                  " tab and backspace are smart
set softtabstop=2
set tabstop=2                 " 4 spaces
set ttyfast                   " we have a fast terminal
set switchbuf=""
set undolevels=500            " 500 undos
set wrapscan " Searches wrap around end of file
set visualbell t_vb=          " Disable ALL bells
set whichwrap+=<,>,h,l        " backspaces and cursor keys wrap to
set wrapscan " Searches wrap around end of file
syntax on

" Resize splits when the window is resized
"au VimResized * :wincmd =

" jump to the beginning and end of functions

set dictionary=/usr/share/dict/words " more words!


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
" spelling checker, toggle with ,ss or F6
setlocal spell spelllang=en
nmap <LocalLeader>ss :set spell!<CR>
nmap <F6> :set spell!<CR>

" default to no spelling
set nospell
"Shortcuts using <LocalLeader>
map <LocalLeader>sn ]s
map <LocalLeader>sp [
map <LocalLeader>sa zg
map <LocalLeader>s? z=
" When I'm pretty sure that the first suggestion is correct
map <LocalLeader>s! 1z=
" I don't know what ; does anyway
map ; :

" nnoremap ~ :ls<cr>:b

" some useful mappings
" Y yanks from cursor to $
"map Y y$
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
inoremap # X<BS>#
" When I forget I'm in Insert mode, how often do you type 'jj' anyway?
imap jj <Esc>
imap jk <Esc>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" set list to activate whitespace detection mode
au BufNewFile,BufRead *.less set filetype=less
au BufRead,BufNewFile {Vagrantfile,Capfile,Gemfile,Rakefile,Thorfile,config.ru,.caprc,.irbrc,irb_tempfile*} set ft=ruby
au BufRead,BufNewFile {*/*playbooks*/*.yml,*/*playbooks*/*.yaml,*/*roles*/*.yaml,*/*roles*/*.yml} set filetype=ansible
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType yml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType ansible setlocal ts=2 sts=2 sw=2 expandtab

" quickfix window with fugitive
autocmd QuickFixCmdPost *grep* cwindow

augroup myvimrc
    au!
    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END



" Wildmenu completion {{{
set wildmenu
set wildmode=list:longest

set wildignore+=*.jpg,*.jpeg,*.gif,*.png,*.gif,*.psd,*.o,*.obj,*.min.js
set wildignore+=*/bower_components/*,*/node_modules/*
set wildignore+=*/smarty/*,*/vendor/*,*/.git/*,*/.hg/*,*/.svn/*,*/.sass-cache/*,*/log/*,*/tmp/*,*/build/*,*/ckeditor/*,*/doc/*,*/source_maps/*,*/dist/*
set wildignore+=.DS_Store
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

" Fugitive mapping
nmap <leader>gb :Gblame<cr>
nmap <leader>gc :Gcommit<cr>
nmap <leader>gd :Gdiff<cr>
nmap <leader>gg :Ggrep
nmap <leader>gl :Glog<cr>
nmap <leader>gp :Git pull<cr>
nmap <leader>gP :Git push<cr>
nmap <leader>gs :Gstatus<cr>
nmap <leader>gw :Gbrowse<cr>

" Enable cursor line position tracking with ,c
set cursorline
nmap <LocalLeader>c :set cursorline nocursorline!<CR>

let g:ansible_options = {'ignore_blank_lines': 0}
let g:ansible_options = {'documentation_mapping': '<C-K>'}

vmap <C-c> y:call SendViaOSC52(getreg('"'))<cr>

"command! -bang -nargs=* -complete=file -bar Grep silent! grep! <args>

" you should really leave comments for things you toggle on and off
" all the time. I added this again for nvim, on osx
nnoremap <BS> <C-^>

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'dikiaap/minimalist'
Plug 'junegunn/vim-easy-align'
Plug 'mileszs/ack.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'plasticboy/vim-markdown'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround/'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'Yggdroot/LeaderF'
call plug#end()

" You have to call :PlugInstall

function! SourceDirectory(file)
  for s:fpath in split(globpath(a:file, '*.vim'), '\n')
    exe 'source' s:fpath
  endfor
endfunction

call SourceDirectory('~/.vim/functions')
