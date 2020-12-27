" Plugin Loader
" =============

" Pre-plugin configs.
" -------------------
"  These need to be configured before we load plugins.
let g:ale_disable_lsp=1
let g:polyglot_disabled=['markdown']
let g:markdown_enable_conceal=1

call plug#begin(stdpath('data').'/plugged')

" Core Plugins
" ------------

" Syntax Highlighting
Plug 'sheerun/vim-polyglot'
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
Plug 'mengelbrecht/lightline-bufferline'
" File System Explorer
Plug 'preservim/nerdtree'
" Palenight Theme
Plug 'drewtempelmeyer/palenight.vim'

" Other Plugins
" -------------

" Extra snippets
Plug 'honza/vim-snippets'
" Comment/Uncomment Assistance (because I'm slow)
Plug 'tpope/vim-commentary'
" Highlight `f/F` Letters
Plug 'unblevable/quick-scope'
" Git Client
Plug 'tpope/vim-fugitive'
" Surrounding brackets/tags/whatever.
Plug 'tpope/vim-surround'
" Git History Viewer
Plug 'junegunn/gv.vim'
" Git Gutter
Plug 'mhinz/vim-signify'
" Live Markdown Previewer.
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
" LaTeX!
Plug 'lervag/vimtex', {'tag': 'v1.6'}
Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'}
" Live LaTeX Previewer.
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
" Fade inactive splits.
Plug 'TaDaa/vimade'
" Dim in-active paragraphs.
Plug 'junegunn/limelight.vim'
" A personal wiki!
Plug 'lervag/wiki.vim'
" Bullet points (for Markdown), because the replacement Markdown
" plugins all suck.
Plug 'dkarter/bullets.vim'

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

" Markdown Preview
" ----------------

let g:mkdp_browser='firefox'
let g:mkdp_highlight_css='~/.vim/markdown_preview.css'
let g:mkdp_port='7237'

" Latex Live Preview
" ------------------

let g:livepreview_cursorhold_recompile=0

" Wiki
" ----

let g:wiki_root='~/notes'
let g:wiki_filetypes=['md', 'markdown']
let g:wiki_journal={
\   'name': 'journal',
\   'frequency': 'weekly',
\   'date_format': {
\     'weekly': '%Y-week%V',
\   },
\ }

" Bullet points
" -------------

let g:bullets_enabled_file_types = [
    \ 'markdown',
    \ 'text',
    \ 'gitcommit',
    \ 'scratch'
    \]
