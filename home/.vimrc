set expandtab

" Necesary for lots of cool vim things
set nocompatible

" Use Pathogen from non-default path
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

"{{{ Misc Settings
"
set backspace=indent,eol,start

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
set statusline+=%{FugitiveStatusline()}      " fugitive
set statusline+=%{ObsessionStatus()}      " fugitive
set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}\  " highlight

" Unset highlighting after search
nnoremap <CR> :noh<CR><CR>

" Highlight word under cursor
nnoremap <F2> :match StatusLineTerm /<C-R><C-W>/<CR>

" Case sensitive
set noic

" Highlight trailing whitespace.
au ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h,*.cpp,*.hpp,*.cc,*.hh match ExtraWhitespace /\s\+$/
au BufEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\s\+$/

" Remove Trailing whitespace
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

set nowrap

filetype plugin indent on

colorscheme slate
if &diff
    colorscheme industry
endif

" After colorscheme so that this color doesn't get overriden
set colorcolumn=150
highlight ColorColumn ctermbg=red

set pastetoggle=<F8>

" }}}

let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

nmap <F7> :TagbarToggle<CR>

" optional reset cursor on start:
augroup myCmds
au!
autocmd VimEnter * silent !echo -ne "\e[2 q"
autocmd FileType gitcommit :setlocal spell spelllang=en_gb
augroup END


autocmd User SignifyHunk call s:show_current_hunk()

" Show hunk number usimg SignifyHunk
" Triggered when jumping to hunk by ]c
function! s:show_current_hunk() abort
  let h = sy#util#get_hunk_stats()
  if !empty(h)
    echo printf('[Hunk %d/%d]', h.current_hunk, h.total_hunks)
  endif
endfunction

let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1

" ag integration with vim, for Ack.vim
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

" vim lsp
" leader is \
nnoremap <leader>dd :LspDefinition<cr>
nnoremap <leader>dn :LspNextDiagnostic<cr>
nnoremap <leader>dp :LspPreviousDiagnostic<cr>
nnoremap <leader>dr :LspRename<cr>
nnoremap <leader>ds :LspStopServer<cr>
nnoremap <leader>dp :LspPeekDefinition<cr>
nnoremap <leader>dci :LspCallHierarchyIncoming<cr>
nnoremap <leader>dco :LspCallHierarchyOutgoing<cr>
" nnoremap <leader>da :LspCodeAction<cr>
" nnoremap <leader>dh :LspHover<cr>
" nnoremap <leader>df :LspDocumentFormat<cr>

" set runtimepath-=~/.vim/bundle/csv
" set runtimepath-=~/.vim/bundle/vim-lsp
" set runtimepath-=~/.vim/bundle/vim-lsp-settings

if filereadable(expand("~/.vimrc.extra"))
    source ~/.vimrc.extra
endif

" Additional C++ highlighting
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1

" Python useful mappings
" [[ Jump backwards to begin of current/previous toplevel
" [] Jump backwards to end of previous toplevel
" ][ Jump forwards to end of current toplevel
" ]] Jump forwards to begin of next toplevel
" [m Jump backwards to begin of current/previous method/scope
" [M Jump backwards to end of previous method/scope
" ]M Jump forwards to end of current/next method/scope
" ]m Jump forwards to begin of next method/scope
