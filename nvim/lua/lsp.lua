local lspconfig = require("lspconfig")
local null_ls = require("null-ls")

local buf_map = function(bufnr, mode, lhs, rhs, opts)
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or { silent = true })
end

vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float, { noremap = true, silent = true })

local on_attach = function(client, bufnr)
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
  buf_map(bufnr, "n", "<Leader>a", ":LspCodeAction<CR>")
  buf_map(bufnr, "n", "<C-]>", ":LspDef<CR>")

  if client.resolved_capabilities.document_formatting then
    vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync(nil, 3000)")
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
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

lspconfig.gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,

  settings = {
    gopls = {
      gofumpt = false,
      usePlaceholders = true,
      -- TODO: Put this into a Pipe-specific config
      ["local"] = "github.com/pipe-technologies/pipe/backend",
    },
  },
})

lspconfig.pyright.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  handlers = {
    ["textDocument/definition"] = vim.lsp.handlers["textDocument/definition"],
  },
})

lspconfig.hls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  handlers = {
    ["textDocument/definition"] = vim.lsp.handlers["textDocument/definition"],
  },
})

lspconfig.tsserver.setup({
  init_options = {
    preferences = {
      importModuleSpecifierPreference = "non-relative",
      importModuleSpecifierEnding = "minimal",
      -- This is currently in @typescript/next.
      autoImportFileExcludePatterns = {
        -- This reexports every React hook.. absurd.
        "@storybook/addons/**",
      },
    },
  },
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false

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
    ["textDocument/definition"] = function(err, result, method, ...)
      local function filterDTS(value)
        return value.uri ~= nil and string.match(value.uri, ".d.ts") == nil
      end

      if vim.tbl_islist(result) and #result > 1 then
        local filtered_result = filter(result, filterDTS)
        return vim.lsp.handlers["textDocument/definition"](err, filtered_result, method, ...)
      end

      vim.lsp.handlers["textDocument/definition"](err, result, method, ...)
    end,
  },
})

lspconfig.sumneko_lua.setup({
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
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})

local sources = {
  -- JS/TS/JSX/TSX
  null_ls.builtins.diagnostics.eslint_d,
  null_ls.builtins.code_actions.eslint_d,
  null_ls.builtins.formatting.eslint_d,
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
  }),
  -- Lua
  null_ls.builtins.formatting.stylua,
  -- Python
  null_ls.builtins.formatting.black,
  null_ls.builtins.formatting.isort,
  null_ls.builtins.diagnostics.mypy,
  null_ls.builtins.diagnostics.flake8.with({
    args = {
      "--max-line-length=999",
      "--extend-ignore=E203,E402,W503",
      "--format",
      "default",
      "--stdin-display-name",
      "$FILENAME",
      "-",
    },
  }),
  -- Golang
  null_ls.builtins.formatting.goimports,
  null_ls.builtins.formatting.gofumpt,
  null_ls.builtins.formatting.gofmt,
  null_ls.builtins.diagnostics.golangci_lint,
  -- null_ls.builtins.diagnostics.revive,
  -- Nix
  null_ls.builtins.formatting.nixpkgs_fmt,
  -- Postgres
  null_ls.builtins.formatting.pg_format,
  -- Rust
  null_ls.builtins.formatting.rustfmt,
  -- Bash
  null_ls.builtins.diagnostics.shellcheck,
  null_ls.builtins.code_actions.shellcheck,
}

if vim.fn.isdirectory(vim.fn.getcwd() .. "/.semgrep") ~= 0 then
  table.insert(sources, 1, null_ls.builtins.diagnostics.semgrep)
end

null_ls.setup({
  root_dir = lspconfig.util.root_pattern(".null-ls-root", "Makefile", "tsconfig.json", "go.mod", "poetry.toml", ".git"),
  sources = sources,
  on_attach = on_attach,
})
