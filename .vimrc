set expandtab

" Necesary for lots of cool vim things
set nocompatible  

execute pathogen#infect()

"{{{ Misc Settings
"
set backspace=indent,eol,start

set colorcolumn=150
highlight ColorColumn ctermbg=red

" This shows what you are typing as a command
set showcmd

" Folding Stuffs
set foldmethod=syntax

" Show matching brackets
set showmatch
set matchtime=3

" ctags stuff
set autochdir
set tags=tags;

" Needed for Syntax Highlighting
filetype on
filetype plugin on
syntax enable

set grepprg=grep\ -nH\ $*

set autoindent

" Tab to spaces
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab

" Use english for spellchecking, but don't spellcheck by default
if version >= 700
   set spl=en spell
   set nospell
endif

" Tab completion
set wildmenu
set wildmode=list:longest,full

" Enable mouse support in console
set mouse=a
" Ignore case by default
set ignorecase
set smartcase

inoremap jj <Esc>
nnoremap JJJJ <Nop>

" Incremental searching
set incsearch

" Highlight things that we find with the search
set hlsearch

let g:clipbrdDefaultReg = '+'

" Remove buffer on closing tab
set nohidden

" Show line numbers
set number

" Set off the other paren
highlight MatchParen ctermbg=4

" Status line
set laststatus=2
set statusline=   " clear the statusline for when vimrc is reloaded
set statusline+=%-3.3n\                      " buffer number
set statusline+=%f\                          " file name
set statusline+=%l/%L                        "cursor line/total lines
set statusline+=%h%m%r%w                     " flags
set statusline+=[%{strlen(&ft)?&ft:'none'},  " filetype
set statusline+=%{&fileformat}]              " file format
set statusline+=%=                           " right align
set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}\  " highlight

" Unset highlighting after search
nnoremap <CR> :noh<CR><CR>

"NERDTree
autocmd vimenter * NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeQuitOnOpen = 1
nnoremap <C-n> :NERDTreeToggle<CR>

" }}}

" Highlight trailing whitespace.
highlight ExtraWhitespace ctermbg=red guibg=#600000
au ColorScheme * highlight ExtraWhitespace guibg=red
au BufEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\s\+$/

" Remove Trailing whitespace
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

set nowrap

filetype plugin indent on

colorscheme elflord

set pastetoggle=<F8>

if filereadable(".vimrc.extra")
    so .vimrc.extra
endif
