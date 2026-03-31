return {
  'github/copilot.vim',
  init = function()
    vim.g.copilot_command = vim.fn.expand '~/.local/share/nvim/mason/bin/copilot-language-server'
  end,
}
