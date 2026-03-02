-- Adds git related signs to the gutter, as well as utilities for managing changes
-- NOTE: gitsigns is already included in init.lua but contains only the base
-- config. This will add also the recommended keymaps.

---@module 'lazy'
---@type LazySpec
return {
  {
    'lewis6991/gitsigns.nvim',
    ---@module 'gitsigns'
    ---@type Gitsigns.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
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

        -- Actions
        -- visual mode
        map('v', '<leader>ghs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = '[g]it [h]unk [s]tage' })
        map('v', '<leader>ghr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = '[g]it [h]unk [r]eset' })
        -- normal mode
        map('n', '<leader>ghs', gitsigns.stage_hunk, { desc = '[s]tage' })
        map('n', '<leader>ghr', gitsigns.reset_hunk, { desc = '[r]eset' })
        map('n', '<leader>gbs', gitsigns.stage_buffer, { desc = '[s]tage' })
        map('n', '<leader>ghu', gitsigns.stage_hunk, { desc = '[u]ndo stage' })
        map('n', '<leader>gbr', gitsigns.reset_buffer, { desc = '[r]eset' })
        map('n', '<leader>ghp', gitsigns.preview_hunk, { desc = '[p]review' })
        map('n', '<leader>glb', gitsigns.blame_line, { desc = '[b]lame' })
        map('n', '<leader>gd', gitsigns.diffthis, { desc = '[d]iff against index' })
        map('n', '<leader>gD', function() gitsigns.diffthis '@' end, { desc = '[D]iff against last commit' })
        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'git show [b]lame line' })
        map('n', '<leader>td', gitsigns.preview_hunk_inline, { desc = 'git show [d]eleted' })
      end,
    },
  },
}
