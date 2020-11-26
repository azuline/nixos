" Plugin Loader
" =============

call plug#begin(stdpath('data') . '/plugged')

" Core Plugins
" ------------

" Syntax Highlighting
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
" Linter and Fixer
Plug 'dense-analysis/ale'
" LSP Client
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Fuzzy Finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Status Bar
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'josa42/vim-lightline-coc'
" File System Explorer
Plug 'preservim/nerdtree'
" Palenight Theme
Plug 'drewtempelmeyer/palenight.vim'

" Other Plugins
" -------------

" Comment/Uncomment Assistance (because I'm slow)
Plug 'tpope/vim-commentary'
" Highlight `f/F` Letters
Plug 'unblevable/quick-scope'
" Git Client
Plug 'tpope/vim-fugitive'
" Git Gutter
Plug 'airblade/vim-gitgutter'
" Live Markdown Previewer.
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
" Live LaTeX Previewer.
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }

call plug#end()

" Miscellaneous Plugin Configuration
" ==================================

" Markdown Preview
let g:mkdp_browser='firefox'
let g:mkdp_highlight_css='~/.vim/markdown_preview.css'
let g:mkdp_port='7237'

" Latex Live Preview
let g:livepreview_cursorhold_recompile=0

" NERDTree
let NERDTreeIgnore = ['build', 'node_modules', '__pycache__', '\.egg-info$', '\.pyc$', '\.o$']
let NERDTreeShowHidden=1
