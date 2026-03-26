return {
  'catgoose/nvim-colorizer.lua',
  enabled = not vim.g.vscode,
  event = 'BufReadPre',
  opts = { -- set to setup table
  },
}
