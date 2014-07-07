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
set autoindent 
set nosmartindent    " auto/smart indent
set expandtab                 " expand tabs to spaces (except java, see autocmd below)
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

"don't use the backup files or swap files, they are annoying to look at
set nobackup
set nowritebackup
set noswapfile
set ai
"set textwidth=79
set comments=b:#

" jump to the beginning and end of functions

nnoremap [[ ?{<CR>w99[{
nnoremap ][ /}<CR>b99]}
nnoremap ]] j0[[%/{<CR>
nnoremap [] k$][%?}<CR>

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
    set statusline+=
    set statusline+=
    set statusline+=%*
  endfunc
  " Not using it at the moment, using a different one
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
" this makes the mouse paste a block of text without formatting it 
" (good for code)
map <MouseMiddle> <esc>"*p

" ---------------------------------------------------------------------------
"  backup options
set viminfo=%100,'100,/100,h,\"500,:100,n~/.viminfo
set history=2000

" ---------------------------------------------------------------------------
" spelling...
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

" ---------------------------------------------------------------------------
" Turn on omni-completion for the appropriate file types.
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1  " Rails support

" ---------------------------------------------------------------------------
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
" When I forget I'm in Insert mode, how often do you type 'jj' anyway?:
imap jj <Esc>

" improved formatting for markdown
autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:>

" set list to activate whitespace detection mode
au BufNewFile,BufRead *.less set filetype=less

au BufRead,BufNewFile {Vagrantfile,Capfile,Gemfile,Rakefile,Thorfile,config.ru,.caprc,.irbrc,irb_tempfile*} set ft=ruby

" For the conque shell plugin
nnoremap <LocalLeader>te :ConqueTermSplit zsh<CR>                            

" Don't go into insert mode when the buffer is focused
let g:ConqueTerm_InsertOnEnter = 0
let g:ConqueTerm_ReadUnfocused = 1
let g:ConqueTerm_TERM = 'xterm'

" Command-T plugin
set wildignore+=*.o,*.so,*.6,*.pyc,build,vendor,tmp,.git
nnoremap <silent> <LocalLeader>t :execute "CommandT " . b:gitroot<CR>
nnoremap <silent> <LocalLeader>b :CommandTBuffer<CR>

" Format json
nmap <LocalLeader>js  :%!python -m json.tool<cr>

let g:pymode_rope_lookup_project = 0

" Don't fold please
set foldlevelstart=99
