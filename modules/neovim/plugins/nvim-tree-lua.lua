local function on_attach_nvim_tree_lua(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return {
      desc = "nvim-tree: " .. desc,
      buffer = bufnr,
      noremap = true,
      silent = true,
      nowait = true,
    }
  end

  local function edit_or_open()
    local node = api.tree.get_node_under_cursor()

    if node.nodes ~= nil then
      api.node.open.edit()
    else
      api.node.open.edit()
      api.tree.close()
    end
  end

  local function vsplit_preview()
    local node = api.tree.get_node_under_cursor()

    if node.nodes ~= nil then
      api.node.open.edit()
    else
      api.node.open.vertical()
    end

    api.tree.focus()
  end

  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set("n", "l", edit_or_open, opts("Edit Or Open"))
  vim.keymap.set("n", "L", vsplit_preview, opts("Vsplit Preview"))
  vim.keymap.set("n", "h", api.tree.close, opts("Close"))
  vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
end

require("nvim-tree").setup({
  filters = {
    dotfiles = false,
    git_ignored = false,
    custom = {
      "^\\.git",
      "^node_modules",
    },
  },
  on_attach = on_attach_nvim_tree_lua,
})

vim.api.nvim_set_keymap("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

