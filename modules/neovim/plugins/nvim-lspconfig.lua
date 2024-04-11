local nvim_lsp = require('lspconfig')

local options = {
  noremap = true,
  silent = true,
}

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, options)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, options)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, options)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, options)

local on_attach = function(_, bufnr)
  local buffer_options = {
    noremap = true,
    silent = true,
    buffer = bufnr
  }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, buffer_options)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, buffer_options)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, buffer_options)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, buffer_options)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, buffer_options)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, buffer_options)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, buffer_options)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, buffer_options)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, buffer_options)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, buffer_options)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, buffer_options)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, buffer_options)
  vim.keymap.set('n', '<space>f', function()
    vim.lsp.buf.format {
      async = true
    }
  end, buffer_options)
end

nvim_lsp.ocamllsp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

nvim_lsp.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
}

nvim_lsp.vimls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

nvim_lsp.nim_langserver.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

nvim_lsp.rust_analyzer.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

nvim_lsp.nil_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

nvim_lsp.clangd.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

