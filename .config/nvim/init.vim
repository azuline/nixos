set spellfile=~/.config/nvim/spell/en.utf-8.add
" set directory=(stdpath('data') . '/swap')

" Fix terminal colors in Alacritty.

if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Load split-configuration files from `config/`.

let g:configs = [
  \   'plug.vim',
  \   'keybinds.vim',
  \   'ui.vim',
  \   'coc.vim',
  \   'ale.vim',
  \ ]

let g:nvim_root = expand('<sfile>:p:h')

for s:cfg in g:configs
  execute printf('source %s/config/%s', g:nvim_root, s:cfg)
endfor
