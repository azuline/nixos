set spellfile=~/.config/nvim/spell/en.utf-8.add

" Keep signcolumn on for gutter plugins.
set signcolumn=yes

" These need to be configured before we load plugins.
let g:ale_disable_lsp=1
let g:polyglot_disabled=['markdown']
let g:markdown_enable_conceal=1

" Fix terminal colors for Palenight
if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

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
