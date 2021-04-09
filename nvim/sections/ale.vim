" ALE Lint & Autofix Engine
" =========================

let g:ale_linters_explicit=1
let g:ale_fix_on_save=1

let g:ale_linters={
  \ 'haskell': [],
  \ 'cpp': ['clang-tidy'],
  \ }

let g:ale_fixers={
  \ }

for lang in keys(g:ale_fixers)
  let g:ale_fixers[lang] = g:ale_fixers[lang] + ['remove_trailing_lines', 'trim_whitespace']
endfor
