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
" Fold on indent for python
autocmd FileType python setlocal foldmethod=indent

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
"set mouse=a

" Ignore case by default
set ignorecase
set smartcase

inoremap jj <Esc>
nnoremap JJJJ <Nop>

" Vsplit open on the right
set splitright

" Incremental searching
set incsearch

" Highlight things that we find with the search
set hlsearch

let g:clipbrdDefaultReg = '+'

" Remove buffer on closing tab
set nohidden

" Show line numbers
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" Set off the other paren
highlight MatchParen ctermbg=4

" Status line
set laststatus=2
set statusline=   " clear the statusline for when vimrc is reloaded
set statusline+=%-3.3n\                      " buffer number
set statusline+=%F\                          " file name
set statusline+=%l/%c/%L                     " cursor line/total lines
set statusline+=%h%m%r%w                     " flags
set statusline+=[%{strlen(&ft)?&ft:'none'},  " filetype
set statusline+=%{&fileformat}]              " file format
set statusline+=%=                           " right align
set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}\  " highlight

" Unset highlighting after search
nnoremap <CR> :noh<CR><CR>

" Highlight word under cursor
nnoremap <F2> :match StatusLineTerm /<C-R><C-W>/<CR>

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

" Case sensitive
set noic

" Highlight trailing whitespace.
au ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match ExtraWhitespace /\s\+$/
au BufEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\s\+$/

" Remove Trailing whitespace
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

set nowrap

filetype plugin indent on

colorscheme elflord
if &diff
    colorscheme industry
endif


set pastetoggle=<F8>

" }}}

if filereadable(expand("~/.vimrc.extra"))
    source ~/.vimrc.extra
endif

let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" optional reset cursor on start:
augroup myCmds
au!
autocmd VimEnter * silent !echo -ne "\e[2 q"
autocmd FileType gitcommit :setlocal spell spelllang=en_gb
augroup END
