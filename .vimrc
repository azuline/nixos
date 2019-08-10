set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

Plugin 'w0rp/ale'
Plugin 'ajh17/VimCompletesMe'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-commentary'
Plugin 'unblevable/quick-scope'
Plugin 'iamcco/markdown-preview.nvim'
Plugin 'nvie/vim-flake8'
Plugin 'psf/black'
Plugin 'lervag/vimtex'
Plugin 'elixir-editors/vim-elixir'
Plugin 'rust-lang/rust.vim'
Plugin 'Vimjas/vim-python-pep8-indent'

call vundle#end()
filetype plugin indent on
syntax on

set background=dark
set hlsearch

" Line numbers
set number
set relativenumber

set whichwrap=b,s,<,>,[,]
set nu
set autoindent

" Trailing space highlighting
highlight BadWhitespace ctermbg=red guibg=red
au BufRead,BufNewFile * match BadWhitespace /\s\+$/

" Indentation
au BufRead,BufNewFile *
    \ set expandtab |
    \ set autoindent |
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set fileformat=unix

au BufRead,BufNewFile *.md,*.py,*.txt,*.rst
    \ set textwidth=79

au BufRead,BufNewFile *.md,*.js,*.yml,*.html,*.css,*.json
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2

au BufRead,BufNewFile Makefile,makefile,*.c set noexpandtab

" Linting
let g:ale_linters={
\ 'python': ['flake8']
\ }

let g:ale_fixers={
\ 'python': ['isort'],
\ 'markdown': ['prettier'],
\ 'css': ['prettier'],
\ 'javascript': ['prettier'],
\ 'json': ['prettier'],
\ }

let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1
let python_highlight_all = 1

let g:black_linelength = 79
let g:black_skip_string_normalization = 1

autocmd BufWritePre *.py execute ':Black'

" Completion
autocmd FileType python let b:vcm_tab_complete = 'python'

" MarkdownPreview
let g:mkdp_browser='firefox-esr'
let g:mkdp_highlight_css='/etc/dotfiles/markdown_preview.css'
let g:mkdp_port='7237'
map <C-m> :MarkdownPreview<CR>

" Reopen file to last read line
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

set backspace=indent,eol,start  " more powerful backspacing

" runtime override.vim
