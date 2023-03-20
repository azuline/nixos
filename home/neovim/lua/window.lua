do -- Treesitter Configuration
  require("nvim-treesitter.configs").setup({
    -- We install most parsers through Nix, but a few are erroring, probably
    -- due to some version mismatch. We install those here instead.
    -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1019#issuecomment-811658387
    highlight = {
      enable = true, -- false will disable the whole extension
      disable = {}, -- list of language that will be disabled
      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      additional_vim_regex_highlighting = true,
    },
    indent = {
      enable = false,
    },
    textsubjects = {
      enable = true,
      prev_selection = ",", -- (Optional) keymap to select the previous selection
      keymaps = {
        ["."] = "textsubjects-smart",
        [";"] = "textsubjects-container-outer",
        ["i;"] = "textsubjects-container-inner",
      },
    },
  })
end

do -- Astro
  vim.g.astro_typescript = "enable"
  vim.cmd([[
		autocmd BufNewFile,BufRead *.astro setfiletype astro
	]])
end

do -- LaTeX syntax stuffs
  -- Configure some LaTeX behaviors.
  vim.g.tex_flavor = "latex"
  vim.g.vimtex_quickfix_mode = 0
  vim.g.vimtex_view_method = "general"
  vim.g.vimtex_view_general_viewer = "evince"
  vim.g.vimtex_view_enabled = 1
  -- For vim-conceal.
  vim.opt.conceallevel = 2
  vim.g.tex_conceal = "abdmg"
  vim.g.tex_conceal_frac = 1
  -- Extra conceal matches.
  vim.cmd('syntax match textCmdStyleBold "\\mathbf>s*" skipwhite skipnl nextgroup=texStyleBold conceal')
end

do -- Configure the statusbar.
  vim.opt.laststatus = 2
  vim.opt.showmode = false

  vim.g["lightline"] = {
    colorscheme = "palenight",
    separator = {
      left = "",
      right = "",
    },
    subseparator = {
      left = "",
      right = "",
    },
    tabline = {
      left = { { "buffers" } },
    },
    component_expand = {
      linter_hints = "lightline#lsp#hints",
      linter_infos = "lightline#lsp#infos",
      linter_warnings = "lightline#lsp#warnings",
      linter_errors = "lightline#lsp#errors",
      linter_ok = "lightline#lsp#ok",
      buffers = "lightline#bufferline#buffers",
    },
    component_type = {
      linter_checking = "right",
      linter_infos = "right",
      linter_warnings = "warning",
      linter_errors = "error",
      linter_ok = "right",
      buffers = "tabsel",
    },
    active = {
      left = {
        { "mode", "paste" },
        { "readonly", "filename", "modified", "helloworld" },
      },
      right = {
        { "lineinfo" },
        { "percent" },
        { "linter_checking", "linter_errors", "linter_warnings", "linter_infos", "linter_ok" },
        { "fileformat", "fileencoding", "filetype" },
      },
    },
  }
end

do -- Multiple Cursors
  -- The vim multi cursors are invisible in default theme.
  vim.g.VM_theme = "nord"
end

do -- Highlight on Yank
  vim.cmd([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]])
end

do -- Set up Palenight theme
  -- Theme Fixes
  vim.cmd([[
    if exists("+termguicolors")
      let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
      set termguicolors
    endif
  ]])

  -- Italics for my favorite color scheme
  vim.g.palenight_terminal_italics = 1

  -- The grays in palenight are too dark.
  vim.g.palenight_color_overrides = {
    gutter_fg_grey = {
      gui = "#657291",
      cterm = "245",
      cterm16 = "15",
    },
    comment_grey = {
      gui = "#7272a8",
      cterm = "247",
      cterm16 = "15",
    },
  }

  -- Set the background.
  vim.opt.background = "dark"
  vim.cmd("colorscheme palenight")
  vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")
end

do -- Git Gutter
  -- Always keep signcolumn on.
  vim.opt.signcolumn = "yes"
  -- Modify signify delete color.
  vim.cmd("highlight SignifySignDelete ctermfg=204 guifg=#ff869a cterm=NONE gui=NONE")
end

-- Support JSON with comments.
vim.cmd([[
  autocmd FileType json syntax match Comment +\/\/.\+$+
]])

-- nvim-treesitter updated their groups, but my theme doesn't support the new groups
-- https://gist.github.com/rockerBOO/be0770242db9b7215b8e83e135516a65
local map = {
  ["annotation"] = "TSAnnotation",
  ["attribute"] = "TSAttribute",
  ["boolean"] = "TSBoolean",
  ["character"] = "TSCharacter",
  ["character.special"] = "TSCharacterSpecial",
  ["comment"] = "TSComment",
  ["conditional"] = "TSConditional",
  ["constant"] = "TSConstant",
  ["constant.builtin"] = "TSConstBuiltin",
  ["constant.macro"] = "TSConstMacro",
  ["constructor"] = "TSConstructor",
  ["debug"] = "TSDebug",
  ["define"] = "TSDefine",
  ["error"] = "TSError",
  ["exception"] = "TSException",
  ["field"] = "TSField",
  ["float"] = "TSFloat",
  ["function"] = "TSFunction",
  ["function.call"] = "TSFunctionCall",
  ["function.builtin"] = "TSFuncBuiltin",
  ["function.macro"] = "TSFuncMacro",
  ["include"] = "TSInclude",
  ["keyword"] = "TSKeyword",
  ["keyword.function"] = "TSKeywordFunction",
  ["keyword.operator"] = "TSKeywordOperator",
  ["keyword.return"] = "TSKeywordReturn",
  ["label"] = "TSLabel",
  ["method"] = "TSMethod",
  ["method.call"] = "TSMethodCall",
  ["namespace"] = "TSNamespace",
  ["none"] = "TSNone",
  ["number"] = "TSNumber",
  ["operator"] = "TSOperator",
  ["parameter"] = "TSParameter",
  ["parameter.reference"] = "TSParameterReference",
  ["preproc"] = "TSPreProc",
  ["property"] = "TSProperty",
  ["punctuation.delimiter"] = "TSPunctDelimiter",
  ["punctuation.bracket"] = "TSPunctBracket",
  ["punctuation.special"] = "TSPunctSpecial",
  ["repeat"] = "TSRepeat",
  ["storageclass"] = "TSStorageClass",
  ["string"] = "TSString",
  ["string.regex"] = "TSStringRegex",
  ["string.escape"] = "TSStringEscape",
  ["string.special"] = "TSStringSpecial",
  ["symbol"] = "TSSymbol",
  ["tag"] = "TSTag",
  ["tag.attribute"] = "TSTagAttribute",
  ["tag.delimiter"] = "TSTagDelimiter",
  ["text"] = "TSText",
  ["text.strong"] = "TSStrong",
  ["text.emphasis"] = "TSEmphasis",
  ["text.underline"] = "TSUnderline",
  ["text.strike"] = "TSStrike",
  ["text.title"] = "TSTitle",
  ["text.literal"] = "TSLiteral",
  ["text.uri"] = "TSURI",
  ["text.math"] = "TSMath",
  ["text.reference"] = "TSTextReference",
  ["text.environment"] = "TSEnvironment",
  ["text.environment.name"] = "TSEnvironmentName",
  ["text.note"] = "TSNote",
  ["text.warning"] = "TSWarning",
  ["text.danger"] = "TSDanger",
  ["todo"] = "TSTodo",
  ["type"] = "TSType",
  ["type.builtin"] = "TSTypeBuiltin",
  ["type.qualifier"] = "TSTypeQualifier",
  ["type.definition"] = "TSTypeDefinition",
  ["variable"] = "TSVariable",
  ["variable.builtin"] = "TSVariableBuiltin",
}

for capture, hlgroup in pairs(map) do
  vim.api.nvim_set_hl(0, "@" .. capture, { link = hlgroup, default = true })
end

local defaults = {
  TSNone = { default = true },
  TSPunctDelimiter = { link = "Delimiter", default = true },
  TSPunctBracket = { link = "Delimiter", default = true },
  TSPunctSpecial = { link = "Delimiter", default = true },
  TSConstant = { link = "Constant", default = true },
  TSConstBuiltin = { link = "Special", default = true },
  TSConstMacro = { link = "Define", default = true },
  TSString = { link = "String", default = true },
  TSStringRegex = { link = "String", default = true },
  TSStringEscape = { link = "SpecialChar", default = true },
  TSStringSpecial = { link = "SpecialChar", default = true },
  TSCharacter = { link = "Character", default = true },
  TSCharacterSpecial = { link = "SpecialChar", default = true },
  TSNumber = { link = "Number", default = true },
  TSBoolean = { link = "Boolean", default = true },
  TSFloat = { link = "Float", default = true },
  TSFunction = { link = "Function", default = true },
  TSFunctionCall = { link = "TSFunction", default = true },
  TSFuncBuiltin = { link = "Special", default = true },
  TSFuncMacro = { link = "Macro", default = true },
  TSParameter = { link = "Identifier", default = true },
  TSParameterReference = { link = "TSParameter", default = true },
  TSMethod = { link = "Function", default = true },
  TSMethodCall = { link = "TSMethod", default = true },
  TSField = { link = "Identifier", default = true },
  TSProperty = { link = "Identifier", default = true },
  TSConstructor = { link = "Special", default = true },
  TSAnnotation = { link = "PreProc", default = true },
  TSAttribute = { link = "PreProc", default = true },
  TSNamespace = { link = "Include", default = true },
  TSSymbol = { link = "Identifier", default = true },
  TSConditional = { link = "Conditional", default = true },
  TSRepeat = { link = "Repeat", default = true },
  TSLabel = { link = "Label", default = true },
  TSOperator = { link = "Operator", default = true },
  TSKeyword = { link = "Keyword", default = true },
  TSKeywordFunction = { link = "Keyword", default = true },
  TSKeywordOperator = { link = "TSOperator", default = true },
  TSKeywordReturn = { link = "TSKeyword", default = true },
  TSException = { link = "Exception", default = true },
  TSDebug = { link = "Debug", default = true },
  TSDefine = { link = "Define", default = true },
  TSPreProc = { link = "PreProc", default = true },
  TSStorageClass = { link = "StorageClass", default = true },
  TSTodo = { link = "Todo", default = true },
  TSType = { link = "Type", default = true },
  TSTypeBuiltin = { link = "Type", default = true },
  TSTypeQualifier = { link = "Type", default = true },
  TSTypeDefinition = { link = "Typedef", default = true },
  TSInclude = { link = "Include", default = true },
  TSVariableBuiltin = { link = "Special", default = true },
  TSText = { link = "TSNone", default = true },
  TSStrong = { bold = true, default = true },
  TSEmphasis = { italic = true, default = true },
  TSUnderline = { underline = true },
  TSStrike = { strikethrough = true },
  TSMath = { link = "Special", default = true },
  TSTextReference = { link = "Constant", default = true },
  TSEnvironment = { link = "Macro", default = true },
  TSEnvironmentName = { link = "Type", default = true },
  TSTitle = { link = "Title", default = true },
  TSLiteral = { link = "String", default = true },
  TSURI = { link = "Underlined", default = true },
  TSComment = { link = "Comment", default = true },
  TSNote = { link = "SpecialComment", default = true },
  TSWarning = { link = "Todo", default = true },
  TSDanger = { link = "WarningMsg", default = true },
  TSTag = { link = "Label", default = true },
  TSTagDelimiter = { link = "Delimiter", default = true },
  TSTagAttribute = { link = "TSProperty", default = true },
}

for group, val in pairs(defaults) do
  vim.api.nvim_set_hl(0, group, val)
end
