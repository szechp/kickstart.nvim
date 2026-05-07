-- Adds git related signs to the gutter, as well as utilities for managing changes

if vim.g.vscode then return end

vim.pack.add { 'https://github.com/lewis6991/gitsigns.nvim' }

require('gitsigns').setup {
  on_attach = function(bufnr)
    local gitsigns = require 'gitsigns'

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gitsigns.nav_hunk 'next'
      end
    end, { desc = 'Jump to next git [c]hange' })

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end, { desc = 'Jump to previous git [c]hange' })

    -- Actions (visual mode)
    map('v', '<leader>ghs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = '[g]it [h]unk [s]tage' })
    map('v', '<leader>ghr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = '[g]it [h]unk [r]eset' })

    -- Actions (normal mode)
    map('n', '<leader>ghs', gitsigns.stage_hunk, { desc = '[s]tage' })
    map('n', '<leader>ghr', gitsigns.reset_hunk, { desc = '[r]eset' })
    map('n', '<leader>gbs', gitsigns.stage_buffer, { desc = '[s]tage' })
    map('n', '<leader>ghu', gitsigns.undo_stage_hunk, { desc = '[u]ndo stage' })
    map('n', '<leader>gbr', gitsigns.reset_buffer, { desc = '[r]eset' })
    map('n', '<leader>ghp', gitsigns.preview_hunk, { desc = '[p]review' })
    map('n', '<leader>glb', gitsigns.blame_line, { desc = '[b]lame' })
    map('n', '<leader>gd', gitsigns.diffthis, { desc = '[d]iff against index' })
    map('n', '<leader>gD', function() gitsigns.diffthis '@' end, { desc = '[D]iff against last commit' })
    map('n', '<leader>ghQ', function() gitsigns.setqflist 'all' end, { desc = '[Q]uickfix (all files)' })
    map('n', '<leader>ghq', gitsigns.setqflist, { desc = '[q]uickfix (this file)' })

    -- Toggles
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'git show [b]lame line' })

    -- Text object
    map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
  end,
}
