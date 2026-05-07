if vim.g.vscode then return end

vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

vim.pack.add { 'https://github.com/chrisgrieser/nvim-origami' }

require('origami').setup {
  foldKeymaps = { setup = false },
  autoFold = { enabled = true, kinds = { 'imports' } },
}
