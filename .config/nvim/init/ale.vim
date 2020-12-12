" ALE Lint & Autofix Engine
" =========================

let g:ale_linters_explicit=1
let g:ale_fix_on_save=1
let g:ale_rust_cargo_use_clippy=1

let g:ale_linters={
  \   'haskell': ['hlint'],
  \   'python': ['flake8', 'mypy'],
  \ }

let g:ale_fixers={
  \   '*': [],
  \   'haskell': ['ormolu'],
  \   'python': ['black', 'isort'],
  \ }

for lang in keys(g:ale_fixers)
  let g:ale_fixers[lang] = g:ale_fixers[lang] + ['remove_trailing_lines', 'trim_whitespace']
endfor
