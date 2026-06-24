# Snippets

vim-vsnip snippets, defined as VSCode-style JSON in `snippets/`. Expand with
`<C-j>`; jump forward `<C-l>`, backward `<C-h>`. They are intentionally not
shown in the completion menu.

`typescriptreact` inherits `typescript`, and `javascriptreact` inherits
`javascript` (see `vsnip_filetypes` in `lua/completion.lua`).

## LaTeX (`tex.json`)

- `s` / `ss` / `sss` — section / subsection / subsubsection
- `s*` / `ss*` / `sss*` — unnumbered section / subsection / subsubsection
- `it` — itemize environment
- `en` — enumerate environment
- `-` — list item (`\item`)
- `i` — italic text (`\ti`)
- `b` — bold text (`\tb`)
- `c` — code/typewriter text (`\tc`)
- `h` — hyperlink (`\href`)
- `t` — hypertarget
- `l` — labelled link (`\hl`)
- `li` — labelled link with italic text
- `f` — footnote (`\fn`)
- `fc` — footnote citation
- `fcc` — footnote citation with optional argument
- `q` — quote environment
- `def` — definition environment
- `thm` — theorem environment
- `lem` — lemma environment
- `cor` — corollary environment
- `rem` — remark environment
- `exm` — example environment
- `al` — unnumbered align math environment (`align*`)
- `all` — numbered align math environment (`align`)
- `pm` — pmatrix math environment
- `p` — problem
- `pp` — problem part

## TypeScript (`typescript.json`)

- `cl` — `console.log` of the clipboard value, labelled with its source text
- `el` — `// eslint-disable-next-line` comment

## TypeScript React (`typescriptreact.json`)

- `nc` — new `React.FC` component
- `nce` — new exported `React.FC` component
- `ncp` — new `React.FC` component with a props type
- `ncep` — new exported `React.FC` component with a props type
- `cl` — `console.log` of the clipboard value, labelled with its source text

## Go (`go.json`)

- `en` — `if err != nil` block with an empty body
- `enr` — `if err != nil` block that returns `err`
- `ennr` — `if err != nil` block that returns `nil, err`
- `tr` — `t.Run` table-test subtest

## Python (`python.json`)

- `pd` — debug print of a variable using an f-string (`print(f"{x=}")`)
