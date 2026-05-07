if vim.g.vscode then return end

vim.pack.add { 'https://github.com/luukvbaal/statuscol.nvim' }

vim.opt.fillchars = { foldclose = '˃', foldopen = '˅', foldsep = ' ' }
vim.o.foldcolumn = '1'

local function lnum_both()
  local relnum = vim.v.lnum == vim.fn.line '.' and 0 or math.abs(vim.v.lnum - vim.fn.line '.')
  return string.format('%3d %2d', vim.v.lnum, relnum)
end

local builtin = require 'statuscol.builtin'
require('statuscol').setup {
  segments = {
    { text = { ' ' } },
    { sign = { namespace = { '.*' }, name = { '.*' }, auto = true } },
    { sign = { namespace = { 'gitsigns' }, colwidth = 1 }, click = 'v:lua.ScSa' },
    { text = { lnum_both, ' ' }, condition = { true }, click = 'v:lua.ScLa' },
    { text = { builtin.foldfunc }, click = 'v:lua.ScFa', colwidth = 1 },
    { text = { ' ' } },
  },
}
