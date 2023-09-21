local lspconfig = require("lspconfig")
local coq = require("coq")
local null_ls = require("null-ls")

local buf_map = function(bufnr, mode, lhs, rhs, opts)
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or { silent = true })
end

vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float, { noremap = true, silent = true })

local on_attach = function(client, bufnr)
  -- LSP breaks `gq` because it overrides formatexpr.
  vim.bo.formatexpr = ""

  vim.cmd("command! LspDef lua vim.lsp.buf.definition({ includeDeclaration = false })")
  vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting()")
  vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
  vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
  vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
  vim.cmd("command! LspRefs lua vim.lsp.buf.references()")
  vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
  vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
  vim.cmd("command! LspDiagPrev lua vim.diagnostic.goto_prev()")
  vim.cmd("command! LspDiagNext lua vim.diagnostic.goto_next()")
  vim.cmd("command! LspDiagLine lua vim.diagnostic.open_float()")
  vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")

  buf_map(bufnr, "n", "<Leader>rn", ":LspRename<CR>")
  buf_map(bufnr, "n", "K", ":LspHover<CR>")
  buf_map(bufnr, "n", "[g", ":LspDiagPrev<CR>")
  buf_map(bufnr, "n", "]g", ":LspDiagNext<CR>")
  buf_map(bufnr, "n", "<Leader>la", ":LspCodeAction<CR>")
  buf_map(bufnr, "n", "<Leader>lr", ":LspRefs<CR>")
  buf_map(bufnr, "n", "<C-]>", ":LspDef<CR>")

  if client.server_capabilities.documentFormattingProvider then
    vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ timeout_ms = 3000 })")
  end
end

-- To avoid react.d.ts definitions from opening on jump to definition.
-- https://github.com/typescript-language-server/typescript-language-server/issues/216#issuecomment-1005272952
local function filter(arr, fn)
  if type(arr) ~= "table" then
    return arr
  end

  local filtered = {}
  for k, v in pairs(arr) do
    if fn(v, k, arr) then
      table.insert(filtered, v)
    end
  end

  return filtered
end

-- Setup lspconfig.
local capabilities = vim.lsp.protocol.make_client_capabilities()

lspconfig.gopls.setup(coq.lsp_ensure_capabilities({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    gopls = {
      gofumpt = false,
      usePlaceholders = false,
      -- TODO: Put this into a Pipe-specific config
      ["local"] = "github.com/pipe-technologies/pipe/backend",
    },
  },
}))

lspconfig.pyright.setup(coq.lsp_ensure_capabilities({
  on_attach = on_attach,
  capabilities = capabilities,
  handlers = {
    ["textDocument/definition"] = vim.lsp.handlers["textDocument/definition"],
  },
}))

lspconfig.hls.setup(coq.lsp_ensure_capabilities({
  on_attach = on_attach,
  capabilities = capabilities,
  handlers = {
    ["textDocument/definition"] = vim.lsp.handlers["textDocument/definition"],
  },
}))

lspconfig.zls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  handlers = {
    ["textDocument/definition"] = vim.lsp.handlers["textDocument/definition"],
  },
})

lspconfig.tsserver.setup(coq.lsp_ensure_capabilities({
  init_options = {
    preferences = {
      importModuleSpecifierPreference = "non-relative",
      importModuleSpecifierEnding = "minimal",
      autoImportFileExcludePatterns = {
        -- This reexports every React hook.. absurd.
        "**/@storybook/addons/**",
        -- This exports a `t`.
        "**/msw/**",
        -- This also exports a `t`.
        "**/vitest/dist/**",
        -- Never import from stories.
        "**/*.stories.tsx",
      },
    },
  },
  on_attach = function(client, bufnr)
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false

    local ts_utils = require("nvim-lsp-ts-utils")
    ts_utils.setup({
      update_imports_on_move = true,
    })
    ts_utils.setup_client(client)
    buf_map(bufnr, "n", "<Leader>i", ":TSLspImportAll<CR>")
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  handlers = {
    ["textDocument/definition"] = function(err, result, method)
      -- https://github.com/typescript-language-server/typescript-language-server/issues/216
      local function filterDTS(value)
        if value.targetUri ~= nil then
          return string.match(value.targetUri, "%.d.ts") == nil
        end
        return string.match(value.uri, "%.d.ts") == nil
      end

      if vim.tbl_islist(result) and #result > 1 then
        local filtered_result = filter(result, filterDTS)
        return vim.lsp.handlers["textDocument/definition"](err, filtered_result, method)
      end

      vim.lsp.handlers["textDocument/definition"](err, result, method)
    end,
  },
}))

lspconfig.lua_ls.setup(coq.lsp_ensure_capabilities({
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        -- Shut up on the luassert startup prompt.
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}))

local sources = {
  -- JS/TS/JSX/TSX
  null_ls.builtins.diagnostics.eslint_d,
  null_ls.builtins.code_actions.eslint_d,
  -- null_ls.builtins.formatting.eslint_d,
  -- Lua
  null_ls.builtins.formatting.stylua,
  -- Python
  null_ls.builtins.formatting.black,
  null_ls.builtins.formatting.isort,
  null_ls.builtins.formatting.ruff,
  null_ls.builtins.diagnostics.mypy,
  null_ls.builtins.diagnostics.ruff,
  -- Golang
  null_ls.builtins.formatting.gofumpt,
  -- null_ls.builtins.diagnostics.golangci_lint,
  -- null_ls.builtins.diagnostics.revive,
  -- Nix
  null_ls.builtins.formatting.nixpkgs_fmt,
  -- Rust
  null_ls.builtins.formatting.rustfmt,
  -- Bash
  null_ls.builtins.diagnostics.shellcheck,
  null_ls.builtins.code_actions.shellcheck,
  -- Zig
  null_ls.builtins.formatting.zigfmt,
}

if vim.fn.isdirectory(vim.fn.getcwd() .. "/.semgrep") ~= 0 then
  table.insert(sources, 1, null_ls.builtins.diagnostics.semgrep)
end

if vim.fn.filereadable(vim.fn.getcwd() .. "/dprint.json") ~= 0 then
  table.insert(sources, 1, null_ls.builtins.formatting.dprint)
end

-- I left pipe, but for future Go codebases, we should do something similar.
-- if string.find(vim.fn.getcwd(), "/pipe/pipe") ~= nil then
--   table.insert(
--     sources,
--     #sources - 1,
--     null_ls.builtins.formatting.goimports.with({
--       extra_args = { "-local", "github.com/pipe-technologies/pipe/backend" },
--     })
--   )
-- else
table.insert(sources, #sources - 1, null_ls.builtins.formatting.goimports)
-- end

if
  vim.fn.filereadable(vim.fn.getcwd() .. "/.prettierrc.js") ~= 0
  or vim.fn.filereadable(vim.fn.getcwd() .. "/../.prettierrc.js") ~= 0
  or vim.fn.filereadable(vim.fn.getcwd() .. "/.prettierrc.json") ~= 0
  or vim.fn.filereadable(vim.fn.getcwd() .. "/../.prettierrc.json") ~= 0
then
  table.insert(
    sources,
    1,
    null_ls.builtins.formatting.prettierd.with({
      filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "css",
        "scss",
        "less",
        "html",
        "json",
        "yaml",
        "markdown",
        "markdown.mdx",
        "graphql",
      },
    })
  )
end

null_ls.setup({
  root_dir = lspconfig.util.root_pattern(".null-ls-root", "Makefile", "tsconfig.json", "go.mod", "poetry.toml", ".git"),
  sources = sources,
  on_attach = on_attach,
})
