if vim.g.vscode then return end

vim.pack.add { 'https://github.com/folke/flash.nvim' }

require('flash').setup {
  modes = {
    search = { enabled = true },
    char = { jump_labels = true },
  },
}

-- Keymaps commented out intentionally:
-- vim.keymap.set({ 'n', 'x', 'o' }, '<c-s>', function() require('flash').jump() end, { desc = 'Flash' })
-- vim.keymap.set({ 'n', 'x', 'o' }, 'S', function() require('flash').treesitter() end, { desc = 'Flash Treesitter' })
