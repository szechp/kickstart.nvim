-- Provide a configurable 'statuscolumn' and click handlers
--- @module 'lazy'
--- @type LazySpec
return {
  'luukvbaal/statuscol.nvim',
  enabled = not vim.g.vscode,
  config = function()
    vim.opt.fillchars = vim.g.have_nerd_font and { foldclose = '', foldopen = '', foldsep = ' ' } or { foldclose = '˃', foldopen = '˅', foldsep = ' ' }
    vim.o.foldcolumn = '1'

    -- Custom function to show both absolute and relative line numbers
    local function lnum_both()
      local lnum = vim.v.lnum
      local relnum = vim.v.lnum == vim.fn.line '.' and 0 or math.abs(vim.v.lnum - vim.fn.line '.')
      return string.format('%3d %2d', lnum, relnum)
    end

    local builtin = require 'statuscol.builtin'
    require('statuscol').setup {
      -- configuration goes here, for example:
      segments = {
        { text = { ' ' } }, -- whitespace padding
        {
          sign = {
            namespace = { '.*' },
            name = { '.*' },
            auto = true,
          },
        },
        {
          sign = { namespace = { 'gitsigns' }, colwidth = 1 },
          click = 'v:lua.ScSa',
        },
        { text = { lnum_both, ' ' }, condition = { true }, click = 'v:lua.ScLa' }, -- line number that can be configured through a few options
        { text = { builtin.foldfunc }, click = 'v:lua.ScFa', colwidth = 1 }, -- fold column that does not print the fold depth digits
        { text = { ' ' } }, -- whitespace padding
      },
    }
  end,
}
