local status, telescope = pcall(require, 'telescope')
if (not status) then
  return
end

local builtin = require('telescope.builtin')

telescope.setup({
  defaults = {
    sorting_strategy = "ascending",
    winblend = 5,
    layout_strategy = "vertical",
    layout_config = {
      height = 0.9,
    },
    file_ignore_patterns = {
      "^.git/",
      "DS_Store",
    }
  }
})

local options = {
  noremap = true,
  silent = true
}

vim.keymap.set('n', '<C-p>', builtin.find_files, options)
vim.keymap.set('n', '<C-g>', builtin.live_grep, options)
vim.keymap.set('n', '<C-f>', "<Cmd>Telescope frecency<CR>", options)

