local imap = require('cookie.keymap').imap
local nmap = require('cookie.keymap').nmap
local buf_imap = require('cookie.keymap').buf_imap
local buf_nmap = require('cookie.keymap').buf_nmap
local telescope_mapper = require('cookie.telescope.mappings')
local handlers = require ('cookie.lsp.handlers')
local lspconfig_util = require('lspconfig.util')

local has_lsp, lspconfig = pcall(require, 'lspconfig')
if not has_lsp then 
    return
end

local custom_init = function(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

local augroup_highlight = vim.api.nvim_create_augroup("custom-lsp-references", { clear = true })
local augroup_codelens = vim.api.nvim_create_augroup("custom-lsp-codelens", { clear = true })
local augroup_format = vim.api.nvim_create_augroup("custom-lsp-format", { clear = true })
local augroup_semantic = vim.api.nvim_create_augroup("custom-lsp-semantic", { clear = true })

local autocmd_format = function(async, filter)
  vim.api.nvim_clear_autocmds { buffer = 0, group = augroup_format }
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = 0,
    callback = function()
      vim.lsp.buf.format { async = async, filter = filter }
    end,
  })
end

local filetype_attach = setmetatable({
  go = function()
    autocmd_format(false)
  end,

  scss = function()
    autocmd_format(false)
  end,

  css = function()
    autocmd_format(false)
  end,

  rust = function()
    telescope_mapper("<space>wf", "lsp_workspace_symbols", {
      ignore_filename = true,
      query = "#",
    }, true)

    autocmd_format(false)
  end,

  cpp = function()
    autocmd_format(false)
  end,

  typescript = function()
    autocmd_format(false, function(clients)
      return vim.tbl_filter(function(client)
        return client.name ~= "tsserver"
      end, clients)
    end)
  end,
}, {
  __index = function()
    return function() end
  end,
})


local custom_init = function(client)
    client.config.flags = client.config.flags or {}
    client.config.flags.allow_incremental_sync = true
end

local custom_attach = function(client)
    local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

    buf_imap { "<c-s>", vim.lsp.buf.signature_help }

    buf_nmap { '<space>cr', vim.lsp.buf.rename }
    buf_nmap { '<space>ca', vim.lsp.buf.code_action }

    buf_nmap { '<space>dn', vim.diagnostic.goto_next }
    buf_nmap { '<space>dp', vim.diagnostic.goto_prev }
    buf_nmap { '<space>sl', vim.diagnostic.open_float }
    buf_nmap { '<space>f', function() vim.lsp.buf.format { async = true } end }

    buf_nmap { "gd", vim.lsp.buf.definition }
    buf_nmap { "gD", vim.lsp.buf.declaration }
    buf_nmap { "gT", vim.lsp.buf.type_definition }
    buf_nmap { 'gi', vim.lsp.buf.implementation }

    telescope_mapper("<space>wd", "lsp_document_symbols", { ignore_filename = true }, true)
    telescope_mapper("<space>ww", "lsp_dynamic_workspace_symbols", { ignore_filename = true }, true)

    telescope_mapper("gr", "lsp_references", nil, true)

    if filetype ~= "lua" then
      buf_nmap { "K", vim.lsp.buf.hover, { desc = "lsp:hover" } }
    end
    
    vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'

    filetype_attach[filetype](client)
end

local updated_capabilities = vim.lsp.protocol.make_client_capabilities()

-- Completion configuration
vim.tbl_deep_extend("force", updated_capabilities, require("cmp_nvim_lsp").default_capabilities())
updated_capabilities.textDocument.completion.completionItem.insertReplaceSupport = false 


---- Configure Languages ----

-- Yaml
lspconfig.yamlls.setup {on_init = custom_init, on_attach = custom_attach}

-- Go
lspconfig.gopls.setup {
    on_init = custom_init,
    on_attach = custom_attach,

    capabilities = updated_capabilities,

    settings = {gopls = {codelenses = {test = true}}}
}

-- Typescript/Javascript
lspconfig.tsserver.setup({
    cmd = {"typescript-language-server", "--stdio"},
    filetypes = {
        "javascript", "javascriptreact", "javascript.jsx", "typescript",
        "typescriptreact", "typescript.tsx"
    },
    on_init = custom_init,
    on_attach = custom_attach
})

require('clangd_extensions').setup {
    server = {
        cmd = {
          "clangd",
          "--background-index",
          "--suggest-missing-includes",
          "--clang-tidy",
          "--header-insertion=iwyu",
        },
        init_options = {
            clangdFileStatus = true,
        },
        on_init = custom_init,
        on_attach = custom_attach
    }
}

-- Rust
lspconfig.rust_analyzer.setup({
    cmd = {"rustup", "run", "stable", "rust-analyzer"},
    filetypes = {"rust"},
    on_init = custom_init,
    on_attach = custom_attach,
    capabilities = updated_capabilities
})

-- Svelte
lspconfig.svelte.setup{
    filetypes={"svelte"},
    on_init = custom_init,
    on_attach = custom_attach,
    capabilities = updated_capabilities
}


return {
  on_init = custom_init,
  on_attach = custom_attach,
  capabilities = updated_capabilities,
}
