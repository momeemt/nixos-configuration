-- requires
local cmp = require("cmp")

-- cmp
cmp.setup({
  mapping = {
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-c>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
  },
})

-- lsp (copilot)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
      vim.lsp.inline_completion.enable(true, { bufnr = bufnr })
      vim.keymap.set("i", "<C-F>", vim.lsp.inline_completion.get, {
        desc = "LSP: accept inline completion",
        buffer = bufnr,
      })
      vim.keymap.set("i", "<C-G>", vim.lsp.inline_completion.select, {
        desc = "LSP: switch inline completion",
        buffer = bufnr,
      })
    end
  end,
})
