--- @module 'lazy'
--- @type LazySpec
return {
  'nvim-treesitter/nvim-treesitter-context',
  enabled = not vim.g.vscode,
  opts = {},
}
