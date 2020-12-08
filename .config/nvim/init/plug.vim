" Plugin Loader
" =============

" Pre-plugin configs.
" -------------------
"  These need to be configured before we load plugins.
let g:ale_disable_lsp=1

call plug#begin(stdpath('data') . '/plugged')

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
Plug 'lervag/vimtex'
" Live LaTeX Previewer.
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
" Fade inactive splits.
Plug 'TaDaa/vimade'
" Dim in-active paragraphs.
Plug 'junegunn/limelight.vim'

call plug#end()

" Miscellaneous Plugin Configuration
" ==================================

" Limelight
" ----

" Configure Limelight colors.
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240
let g:limelight_conceal_guifg = 'DarkGray'
let g:limelight_conceal_guifg = '#777777'

" Include extra surrounding paragraph.
let g:limelight_paragraph_span = 1

" LaTeX
" -----

let g:tex_flavor='latex'
let g:vimtex_quickfix_mode=0
set conceallevel=2
let g:tex_conceal='abdmg'

" Polyglot
" --------

" Polyglot has some issues with markdown files, these settings fix them.
" https://github.com/plasticboy/vim-markdown/issues/126#issuecomment-640890790
" au filetype markdown set formatoptions+=ro
" au filetype markdown set comments=b:*,b:-,b:+,b:1.,n:>

" FZF
" ---

let g:fzf_preview_window = ['up:40%:hidden', 'ctrl-/']

" Markdown Preview
" ----------------

let g:mkdp_browser='firefox'
let g:mkdp_highlight_css='~/.vim/markdown_preview.css'
let g:mkdp_port='7237'

" Latex Live Preview
" ------------------

let g:livepreview_cursorhold_recompile=0
