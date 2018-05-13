" General.
let mapleader=','
let maplocalleader=','        " all my shortcuts start with ,
set ttyfast " Send more characters at a given time
set noshowcmd noruler
set cursorline " Highlight current line
set expandtab " Expand tabs to spaces
set guicursor= " Disable cursor style changes in Neovim
"set hidden " When a buffer is brought to foreground, remember undo history and marks
set history=500 " Increase history from 20 default to 1000
set hlsearch " Highlight searches
set ignorecase
set incsearch " Highlight dynamically as pattern is typed
set laststatus=2 " Always show status line
set magic " Enable extended regexes
set noerrorbells " Disable error bells
set nojoinspaces " Only insert single space after a '.', '?' and '!' with a join command
set noshowmode " Don't show the current mode (airline.vim takes care of us)
set nostartofline " Don't reset cursor to start of line when moving around
set nowrap " Do not wrap lines
set scrolloff=8 " Start scrolling three lines before horizontal border of window
set shell=/bin/bash " Use /bin/sh for executing shell commands
set shiftwidth=4 " The # of spaces for indenting
set shortmess=atI " Don't show the intro message when starting vim
set sidescrolloff=3 " Start scrolling three columns before vertical border of window
set smartcase " Ignore 'ignorecase' if search patter contains uppercase characters
set smarttab " At start of line, <Tab> inserts shiftwidth spaces, <Bs> deletes shiftwidth spaces
set softtabstop=4
set splitbelow " New window goes below
set splitright " New windows goes right
set suffixes=.bak,~,.swp,.swo,.o,.d,.info,.aux,.log,.dvi,.pdf,.bin,.bbl,.blg,.brf,.cb,.dmg,.exe,.ind,.idx,.ilg,.inx,.out,.toc,.pyc,.pyd,.dll
set switchbuf=""
set undofile " Persistent Undo
set visualbell " Use visual bell instead of audible bell (annnnnoying)
set wildchar=<TAB> " Character for CLI expansion (TAB-completion)
set wildignore+=*.jpg,*.jpeg,*.gif,*.png,*.gif,*.psd,*.o,*.obj,*.min.js
set wildignore+=*/bower_components/*,*/node_modules/*
set wildignore+=*/smarty/*,*/vendor/*,*/.git/*,*/.hg/*,*/.svn/*,*/.sass-cache/*,*/log/*,*/tmp/*,*/build/*,*/ckeditor/*,*/doc/*,*/source_maps/*,*/dist/*
set wildignore+=.DS_Store
set wildmenu " Hitting TAB in command mode will show possible completions above command line
set wildmode=list:longest " Complete only until point of ambiguity
set wrapscan " Searches wrap around end of file

" Plugin.
call plug#begin('~/.local/share/nvim/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'dikiaap/minimalist'
Plug 'christoomey/vim-tmux-navigator'
Plug 'junegunn/vim-plug'
Plug 'junegunn/vim-easy-align'
Plug 'mileszs/ack.vim'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround/'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'prettier/vim-prettier', { 'do': 'npm install', 'for': ['html', 'css', 'sass', 'javascript', 'javascript.jsx', 'json', 'graphql'] }
call plug#end()

tnoremap <Esc> <C-\><C-n>

" Colors, Fonts, and Syntax.
filetype plugin indent on
syntax enable
set t_Co=256
set encoding=utf-8
set guifont=Hack
colorscheme minimalist

map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
noremap <C-n> :tabnext<CR>                                            
noremap <C-p> :tabprev<CR>

" bounce
map <C-D> :bd<cr>

" Directories.
set backupdir=~/.local/share/nvim/backup
set directory=~/.local/share/nvim/swap
set undodir=~/.local/share/nvim/undo

augroup prettier
    autocmd!
    autocmd FileType html,css,sass,javascript,javascript.jsx,json,graphql
                \ nnoremap <buffer><silent> <LocalLeader>f :Prettier<Enter>
augroup end

" my shit
nnoremap ; :
let mapleader=','
let maplocalleader=','        " all my shortcuts start with ,
set whichwrap+=<,>,h,l        " backspaces and cursor keys wrap to
set noautowrite               " don't automagically write on :next
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
set autochdir

map <F1> <Esc>
imap <F1> <Esc>
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
command! -bang E e<bang>
command! -bang Q q<bang>
command! -bang W w<bang>
command! -bang QA qa<bang>
command! -bang Qa qa<bang>
command! -bang Wa wa<bang>
command! -bang WA wa<bang>
command! -bang Wq wq<bang>
command! -bang WQ wq<bang>
" Enable cursor line position tracking with ,c
set cursorline
nmap <LocalLeader>c :set cursorline nocursorline!<CR>
augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END

"set runtimepath^=~/.vim runtimepath+=~/.vim/after
"let &packpath = &runtimepath
"source ~/.vimrc
