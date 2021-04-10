set spellfile=~/.config/nvim/spell/en.utf-8.add

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50

" Fix terminal colors in Alacritty.
if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" These need to be configured before we load plugins.
let g:ale_disable_lsp=1
let g:polyglot_disabled=['markdown']
let g:markdown_enable_conceal=1

" Load split-configuration files from `sections/`.
let g:configs = [
  \   'plug.vim',
  \   'keybinds.vim',
  \   'ui.vim',
  \   'coc.vim',
  \   'ale.vim',
  \ ]

let g:nvim_root = expand('<sfile>:p:h')

for s:cfg in g:configs
  execute printf('source %s/sections/%s', g:nvim_root, s:cfg)
endfor

syntax match textCmdStyleBold '\\mathbf\>\s*' skipwhite skipnl nextgroup=texStyleBold conceal

" Racket filetype.
au BufReadPost,BufNewFile *.rkt set filetype=racket
au filetype racket set lisp
