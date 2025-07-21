local lspconfig = require("lspconfig")
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
  -- Also see navigation.lua's telescope keybinds.

  if client.server_capabilities.documentFormattingProvider then
    vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ timeout_ms = 3000 })")
  end
end

-- Setup lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    gopls = {
      gofumpt = false,
      usePlaceholders = false,
    },
  },
})

lspconfig.pyright.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = lspconfig.util.root_pattern("pyproject.toml"),
  settings = {
    pyright = {
      disableOrganizeImports = true, -- Using Ruff's import organizer
      diagnosticMode = "workspace", -- Otherwise the LSP does not autocomplete in unimported files.
    },
    python = {
      analysis = {
        autoImportCompletions = true,
      },
    },
  },
})

lspconfig.ruff.setup({
  on_attach = function(client, bufnr)
    -- Defer to Pyright's hover.
    if client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end
    local callback = function()
      if vim.bo.ft == "python" then
        -- pcall here so that errors do not spam the ex line with a bunch of shit and block editing for 5 seconds
        local success, _ = pcall(function()
          vim.lsp.buf.code_action({ context = { only = { "source.fixAll.ruff" }, diagnostics = {} }, apply = true })
          vim.lsp.buf.format({ async = false })
        end)
        if success then
          vim.cmd("write")
        end
      end
    end
    vim.api.nvim_create_autocmd("BufWritePost", { callback = callback })
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
})

lspconfig.hls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  handlers = {
    ["textDocument/definition"] = vim.lsp.handlers["textDocument/definition"],
  },
})

lspconfig.clangd.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  handlers = {
    ["textDocument/definition"] = vim.lsp.handlers["textDocument/definition"],
  },
})

lspconfig.zls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  handlers = {
    ["textDocument/definition"] = vim.lsp.handlers["textDocument/definition"],
  },
})

lspconfig.bashls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

if vim.fn.executable("tsc") then
  require("typescript-tools").setup({
    settings = {
      expose_as_code_action = "all",
      tsserver_file_preferences = {
        importModuleSpecifierPreference = "non-relative",
        importModuleSpecifierEnding = "minimal",
        autoImportFileExcludePatterns = {
          -- These are primitive libraries which have been abstracted behind my system/wrappers.
          "**/react-aria-components/**",
          "**/@radix-ui/**",
          "**/sonner/**",
          "**/wouter/**",
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
      client.server_capabilities.documentFormattingProvider = false
      buf_map(bufnr, "n", "<Leader>i", ":TSToolsAddMissingImports<CR>")
      -- vim.api.nvim_create_autocmd("BufWritePre", {
      --   buffer = bufnr,
      --   command = "TSToolsFixAll",
      -- })
      on_attach(client, bufnr)
    end,
    capabilities = capabilities,
  })
end

lspconfig.eslint.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    quiet = true,
    format = false,
    codeActionOnSave = {
      enable = true,
      mode = "all",
    },
  },
})

lspconfig.tailwindcss.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    tailwindCSS = {
      classAttributes = { "class", "className", "tw" },
    },
  },
})

lspconfig.lua_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
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
})

lspconfig.nil_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

lspconfig.biome.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

if vim.fn.filereadable(vim.fn.getcwd() .. "/dprint.json") == 1 then
  lspconfig.dprint.setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })
end

local sources = {
  -- Lua
  null_ls.builtins.formatting.stylua,
  -- JavaScript
  null_ls.builtins.formatting.biome,
  -- Golang
  null_ls.builtins.formatting.gofumpt,
  -- null_ls.builtins.diagnostics.golangci_lint,
  -- null_ls.builtins.diagnostics.revive,
  -- Nix
  null_ls.builtins.formatting.nixpkgs_fmt,
}

if vim.fn.isdirectory(vim.fn.getcwd() .. "/.semgrep") == 1 then
  table.insert(
    sources,
    null_ls.builtins.diagnostics.semgrep.with({
      extra_args = { "--config", vim.fn.getcwd() .. "/.semgrep" },
    })
  )
end

-- I left pipe, but for future Go codebases, we should do something similar.
-- This should also be applied for gopls.
--
-- if string.find(vim.fn.getcwd(), "/pipe/pipe") ~= nil then
--   table.insert(
--     sources,
--     null_ls.builtins.formatting.goimports.with({
--       extra_args = { "-local", "github.com/pipe-technologies/pipe/backend" },
--     })
--   )
-- else
table.insert(sources, null_ls.builtins.formatting.goimports)
-- end

if
  vim.fn.filereadable(vim.fn.getcwd() .. "/.prettierrc.js") ~= 0
  or vim.fn.filereadable(vim.fn.getcwd() .. "/../.prettierrc.js") ~= 0
  or vim.fn.filereadable(vim.fn.getcwd() .. "/.prettierrc.json") ~= 0
  or vim.fn.filereadable(vim.fn.getcwd() .. "/../.prettierrc.json") ~= 0
then
  table.insert(
    sources,
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
  root_dir = lspconfig.util.root_pattern(
    ".null-ls-root",
    "Makefile",
    "tsconfig.json",
    "go.mod",
    "poetry.toml",
    "package.json",
    ".git"
  ),
  sources = sources,
  on_attach = on_attach,
})
