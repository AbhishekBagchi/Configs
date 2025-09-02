" Necesary for lots of cool vim things
set nocompatible

" Use Pathogen from non-default path
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

py3 import os; import sys; sys.executable="/opt/homebrew/opt/python@3.13/Frameworks/Python.framework/Versions/3.13/bin/python3.13"
set expandtab

" Themes
if (has("termguicolors"))
    set termguicolors
endif

" Highlight trailing whitespace.
set background=dark

let g:gruvbox_italic=1
colorscheme gruvbox

if &diff
    colorscheme unokai
endif

" After colorscheme so that this color doesn't get overriden
set colorcolumn=120
augroup py
    autocmd!
    autocmd BufNewFile,BufRead *.py set colorcolumn=120
augroup end
highlight ColorColumn ctermbg=red

au ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h,*.cpp,*.hpp,*.cc,*.hh match ExtraWhitespace /\s\+$/
au BufEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\s\+$/


"{{{ Misc Settings
"
set backspace=indent,eol,start

" This shows what you are typing as a command
set showcmd

" Folding Stuffs
set foldmethod=syntax

" Fold on indent for python
augroup python_indent
    autocmd!
    " Fold on indent for python
    autocmd FileType python setlocal foldmethod=indent
augroup end

" Space to toggle folds in normal mode
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

" Show matching brackets
" set showmatch
" set matchtime=3

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
set number
" augroup numbertoggle
"     autocmd!
"     autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
"     autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber number
" augroup END

" Set off the other paren
highlight MatchParen ctermbg=4

autocmd BufNewFile,BufRead *.v,*.vs,*.ivg set syntax=verilog

function! StatuslineMode()
  let l:mode=mode()
  let l:m=""
  if l:mode==#"n"
    let l:m="NORMAL"
  elseif l:mode==?"v"
    let l:m="VISUAL"
  elseif l:mode==#"i"
    let l:m="INSERT"
  elseif l:mode==#"R"
    let l:m="REPLACE"
  elseif l:mode==?"s"
    let l:m="SELECT"
  elseif l:mode==#"t"
    let l:m="TERMINAL"
  elseif l:mode==#"c"
    let l:m="COMMAND"
  elseif l:mode==#"!"
    let l:m="SHELL"
  endif
  if &paste ==#	1
      let l:mode_return = l:m . " (PASTE) "
      return l:mode_return
  endif
  return l:m
endfunction

" Status line
set laststatus=2
set statusline=   " clear the statusline for when vimrc is reloaded
set statusline+=%-3.3{winnr()}               " window number
set statusline+=%-3.3n\                      " buffer number
set statusline+=%6{StatuslineMode()}\        " mode
set statusline+=%F\                          " file name
set statusline+=%l/%c/%L/%P\                 " cursor line/total lines
set statusline+=%h%m%r%w\                    " flags, help, modified, readonly
set statusline+=[%{strlen(&ft)?&ft:'none'},  " filetype
set statusline+=%{&fileformat}]              " file format
set statusline+=%=                           " right align
set statusline+=%{zoom#statusline()}         " zoom status
set statusline+=%{FugitiveStatusline()}      " fugitive
set statusline+=%{ObsessionStatus()}         " fugitive
" set statusline+=%{synidattr(synid(line('.'),col('.'),1),'name')}\  " highlight

" The status line now has the mode, so another mode isn't needed
set noshowmode

" CtrlP invocation
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'

" Unset highlighting after search
nnoremap <CR> :noh<CR><CR>

" Highlight word under cursor
nnoremap <F2> :match StatusLineTerm /<C-R><C-W>/<CR>

" Case sensitive
set noic

" Remove Trailing whitespace
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

set nowrap

filetype plugin indent on

set pastetoggle=<F8>

" }}}

let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" Automatically read file if changed externally
set autoread


" Plugin configs
" nmap <F7> :TagbarToggle<CR>

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

if filereadable(expand("~/.vimrc.extra"))
    source ~/.vimrc.extra
endif

" Additional C++ highlighting
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1

" context.vim
" highlight MyColor ctermbg=lightblue
" let g:context_highlight_normal='MyColor'
let g:context_skip_regex = '^\s*\($\|#\|//\|/\*\|\*\($\|/s\|\/\)\)'

" vim-signify update time
set updatetime=100

" Python useful mappings
" [[ Jump backwards to begin of current/previous toplevel
" [] Jump backwards to end of previous toplevel
" ][ Jump forwards to end of current toplevel
" ]] Jump forwards to begin of next toplevel
" [m Jump backwards to begin of current/previous method/scope
" [M Jump backwards to end of previous method/scope
" ]M Jump forwards to end of current/next method/scope
" ]m Jump forwards to begin of next method/scope

" let g:loaded_matchparen=1

if has('unix')
  if has('mac')
    set rtp+=/opt/homebrew/opt/fzf
  endif
endif

" let g:jedi#completions_command = "<C-N>"
let g:jedi#show_call_signatures = "1"

" Disable asynccomplete autopopup, Tab to complete
let g:asyncomplete_auto_popup = 0
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" allow modifying the completeopt variable, or it will
" be overridden all the time
let g:asyncomplete_auto_completeopt = 0

set completeopt=menuone,noinsert,noselect,preview
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

" clang-format
let g:clang_format#detect_style_file = 1
" let g:clang_format#auto_format = 1
" autocmd FileType cpp ClangFormatAutoEnable

let g:validator_python_checkers = ['flake8']
" let g:validator_cpp_checkers = ['clang-tidy']
let g:validator_ignore = ['cpp', 'none']
let g:validator_auto_open_quickfix = 1
let g:validator_permament_sign = 1
let g:validator_python_flake8_args = '--max-line-length=120 --extend-ignore=F403,F405,E203,F401,E128'

" CSV config
let g:csv_start = 1
let g:csv_end = 20
let g:csv_strict_columns = 1

" Black
let g:black_linelength = 120

" Isort
let g:isort_vim_options = '--profile black'

" fzf AgIn
" AgIn: Start ag in the specified directory
"
" e.g.
"   :AgIn .. foo
function! s:ag_in(bang, ...)
  if !isdirectory(a:1)
    throw 'not a valid directory: ' .. a:1
  endif
  " Press `?' to enable preview window.
  call fzf#vim#ag(join(a:000[1:], ' '), fzf#vim#with_preview({'dir': a:1}, 'up:50%:hidden', '?'), a:bang)

  " If you don't want preview option, use this
  " call fzf#vim#ag(join(a:000[1:], ' '), {'dir': a:1}, a:bang)
endfunction

command! -bang -nargs=+ -complete=dir AgIn call s:ag_in(<bang>0, <f-args>)

let g:vimcomplete_tab_enable = 1
" yegappan/lsp Keybindings
nnoremap <leader>dd  :LspGotoDefinition<cr>
nnoremap <leader>dn  :LspDiag nextWrap<cr>
nnoremap <leader>dp  :LspDiag prevWrap<cr>
nnoremap <leader>dr  :LspRename<cr>
nnoremap <leader>dpd :LspPeekDefinition<cr>
nnoremap <leader>dpr :LspPeekReferences<cr>
nnoremap <leader>dci :LspIncomingCalls<cr>
nnoremap <leader>dco :LspOutgoingCalls<cr>
nnoremap <leader>da  :LspCodeAction<cr>
nnoremap <leader>dl  :LspCodeLens<cr>
nnoremap <leader>dh  :LspHover<cr>
nnoremap <leader>df  :LspFormat<cr>
nnoremap <leader>do  :LspFold<cr>
nnoremap <leader>ds  :LspDiagShow<cr>
" nnoremap <leader>ds  :LspStopServer<cr>

let g:diminactive_enable_focus = 1
let g:diminactive_use_syntax = 0

set runtimepath-=~/.vim/bundle/vim-lsp
set runtimepath-=~/.vim/bundle/vim-lsp-settings
" set runtimepath-=~/.vim/bundle/asynccomplete
" set runtimepath-=~/.vim/bundle/asynccomplete-vim
set runtimepath-=~/.vim/bundle/context.vim
set runtimepath-=~/.vim/bundle/csv
" set runtimepath-=~/.vim/bundle/vim-signify
set runtimepath-=~/.vim/bundle/vim-buftabline
set runtimepath-=~/.vim/bundle/jed-vim
