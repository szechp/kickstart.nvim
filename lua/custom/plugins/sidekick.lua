return {
  {
    'folke/sidekick.nvim',
    enabled = not vim.g.vscode,
    keys = {
      {
        '<leader>ac',
        function() require('sidekick.cli').toggle({ name = 'copilot', focus = true }) end,
        mode = { 'n', 'v' },
        desc = 'Toggle [c]opilot CLI',
      },
      {
        '<leader>at',
        function() require('sidekick.cli').send({ msg = '{this}' }) end,
        mode = { 'n', 'x' },
        desc = 'Send current function/block to Copilot',
      },
      {
        '<leader>af',
        function() require('sidekick.cli').send({ msg = '{file}' }) end,
        desc = 'Send [f]ile to Copilot',
      },
      {
        '<leader>ap',
        function() require('sidekick.cli').prompt() end,
        mode = { 'n', 'x' },
        desc = 'Select [p]rompt to send',
      },
    },
    opts = {
      cli = {
        tools = {
          copilot = {
            cmd = { 'copilot', '--model', 'claude-opus-4.6', '--alt-screen', 'on' },
          },
        },
      },
    },
  },
}
