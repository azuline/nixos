call plug#begin(stdpath('data').'/plugged')

" Core Plugins
" ------------
" Linter and Fixer
Plug 'dense-analysis/ale'
" LSP Client
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Fuzzy Finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" File System Explorer
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-git-status.vim'
" https://github.com/lambdalisue/fern.vim/issues/120
Plug 'antoinemadec/FixCursorHold.nvim'

" Appearance
" ----------
" Color Scheme
Plug 'drewtempelmeyer/palenight.vim'
" Status Bar
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'josa42/vim-lightline-coc'
Plug 'mengelbrecht/lightline-bufferline'
" Git Gutter
Plug 'mhinz/vim-signify'
" Keep signcolumn on for gutter plugins.
set signcolumn=yes

" Language/Syntax Plugins
" -----------------------
" Generic Syntax Highlighting
Plug 'sheerun/vim-polyglot'
" Golang
Plug 'fatih/vim-go'
" Markdown
Plug 'gabrielelana/vim-markdown'
" Bullet points, because the replacement Markdown plugins all suck.
Plug 'dkarter/bullets.vim'
" LaTeX!
Plug 'lervag/vimtex', {'tag': 'v1.6'}
Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'}

" Editing Augmentation
" --------------------
" Comment/Uncomment Assistance (because I'm slow)
Plug 'tpope/vim-commentary'
" Pluralization & case coercion
Plug 'tpope/vim-abolish'
" Extra text objects
Plug 'wellle/targets.vim'
" Quick movement!
Plug 'justinmk/vim-sneak'
" Text alignment operator
Plug 'tommcdo/vim-lion'
" Repeat for plugins
Plug 'tpope/vim-repeat'

" Other Plugins
" -------------
" Extra snippets
Plug 'honza/vim-snippets'
" Highlight `f/F` Letters
Plug 'unblevable/quick-scope'
" Git Client
Plug 'tpope/vim-fugitive'
" Git History Viewer
Plug 'junegunn/gv.vim'
" A personal wiki!
Plug 'lervag/wiki.vim'

call plug#end()

" Miscellaneous Plugin Configuration
" ==================================

" LaTeX
" -----

let g:tex_flavor='latex'
let g:vimtex_quickfix_mode=0
let g:vimtex_view_general_viewer='evince'

" For vim-conceal.
set conceallevel=2
let g:tex_conceal='abdmg'
let g:tex_conceal_frac=1

" FZF
" ---

let g:fzf_preview_window=['up:40%:hidden', 'ctrl-/']

" Wiki
" ----

let g:wiki_root='~/notes'
let g:wiki_filetypes=['md', 'markdown']

" Bullet points
" -------------

let g:bullets_enabled_file_types = [
    \ 'markdown',
    \ 'text',
    \ 'gitcommit',
    \ 'scratch'
    \]

" vim-go
" ------

" Go syntax highlighting
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1

" Auto formatting and importing
let g:go_fmt_autosave = 0

" Status line types/signatures
let g:go_auto_type_info = 1

" sneak
" -----

let g:sneak#label = 1
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

" quick-scope
" -----------

augroup QuickScopeColors
  autocmd ColorScheme * highlight QuickScopePrimary gui=underline cterm=underline
augroup end

augroup FernQuickScope
  au FileType fern let b:qs_local_disable=1
augroup end
