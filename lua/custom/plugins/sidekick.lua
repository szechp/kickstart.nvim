if vim.g.vscode then return end

vim.pack.add { 'https://github.com/folke/sidekick.nvim' }

require('sidekick').setup {
  cli = {
    tools = {
      copilot = { cmd = { 'copilot' } },
    },
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>ac', function() require('sidekick.cli').toggle { name = 'copilot', focus = true } end, { desc = 'Toggle [c]opilot CLI' })
vim.keymap.set({ 'n', 'x' }, '<leader>at', function() require('sidekick.cli').send { msg = '{this}' } end, { desc = 'Send current function/block to Copilot' })
vim.keymap.set('n', '<leader>af', function() require('sidekick.cli').send { msg = '{file}' } end, { desc = 'Send [f]ile to Copilot' })
vim.keymap.set({ 'n', 'x' }, '<leader>ap', function() require('sidekick.cli').prompt() end, { desc = 'Select [p]rompt to send' })
