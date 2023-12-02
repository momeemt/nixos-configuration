local builtin = require('telescope.builtin')
local options = {
  noremap = true,
  silent = true
}

vim.keymap.set('n', '<C-p>', builtin.find_files, options)
vim.keymap.set('n', '<C-g>', builtin.live_grep, options)
vim.keymap.set('n', '<C-f>', "<Cmd>Telescope frecency<CR>", options)

