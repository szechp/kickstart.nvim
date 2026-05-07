if vim.g.vscode then return end

vim.pack.add { 'https://github.com/folke/snacks.nvim' }

local function open_explorer()
  local pickers = Snacks.picker.get { source = 'explorer' }
  for _, v in pairs(pickers) do v:focus() end
  if #pickers == 0 then Snacks.picker.explorer() end
end

require('snacks').setup {
  notifier = {},
  lazygit = {},
  statuscolumn = { enabled = false },
  gitbrowse = {},
  dashboard = { enabled = false },
  quickfile = {},
  picker = {
    win = {
      input = {
        keys = {
          ['H'] = { 'toggle_hidden', mode = { 'n' } },
          ['I'] = { 'toggle_ignored', mode = { 'n' } },
          ['<a-h>'] = { 'toggle_hidden', mode = { 'i', 'n' } },
          ['<a-i>'] = { 'toggle_ignored', mode = { 'i', 'n' } },
          ['<C-s>'] = { 'history_forward', mode = { 'i', 'n' } },
          ['<C-r>'] = { 'history_back', mode = { 'i', 'n' } },
        },
      },
    },
    sources = {
      grep = { hidden = true, ignored = true },
      explorer = {
        layout = { preset = 'sidebar' },
        enabled = true,
        hidden = true,
        actions = {
          explorer_del = function(picker)
            local _, res = pcall(function() return vim.fn.confirm('Do you want to put files into trash?', '&Yes\n&No\n&Cancel', 1, 'Question') end)
            if res ~= 1 then return end
            for _, item in ipairs(picker:selected { fallback = true }) do
              vim.fn.jobstart('trash ' .. item.file, {
                detach = true,
                on_exit = function() picker:update() end,
              })
            end
          end,
        },
      },
      buffers = { auto_close = true, layout = { preset = 'vscode' } },
      files = { hidden = true, ignored = true },
    },
  },
}

-- gitbrowse
vim.keymap.set('n', '<leader>gw', function() Snacks.gitbrowse.open() end, { desc = 'open in [w]eb browser' })

-- notifications
vim.keymap.set('n', '<leader>snd', function() Snacks.notifier.hide() end, { desc = '[d]ismiss notifications' })

-- picker
vim.keymap.set('n', '<leader>sh', function() Snacks.picker.help() end, { desc = '[h]elp' })
vim.keymap.set('n', '<leader>sk', function() Snacks.picker.keymaps() end, { desc = '[k]eymaps' })
vim.keymap.set('n', '<leader>.', function() Snacks.picker.files() end, { desc = 'find files in [.]/' })
vim.keymap.set('n', '<leader>ss', function() Snacks.picker.pickers() end, { desc = '[s]elect Snacks' })
vim.keymap.set({ 'n', 'x' }, '<leader>sw', function() Snacks.picker.grep_word() end, { desc = 'current [w]ord' })
vim.keymap.set('n', '<leader>/', function() Snacks.picker.grep() end, { desc = 'grep (cwd)' })
vim.keymap.set('n', '<leader>sd', function() Snacks.picker.diagnostics() end, { desc = '[d]iagnostics' })
vim.keymap.set('n', '<leader>sp', function() Snacks.picker.resume() end, { desc = 'resume [p]revious picker' })
vim.keymap.set('n', '<leader>sr', function() Snacks.picker.recent() end, { desc = '[r]ecent Files' })
vim.keymap.set('n', '<leader><leader>', function() Snacks.picker.smart() end, { desc = '[ ] smart picker' })
vim.keymap.set('n', '<leader>sg', function() Snacks.picker.grep_buffers() end, { desc = '[g]rep in Open Files' })
vim.keymap.set('n', '<leader>sN', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, { desc = '[N]eovim files' })

-- git
vim.keymap.set('n', '<leader>gg', function() Snacks.lazygit() end, { desc = 'lazy[g]it' })

-- explorer
vim.keymap.set('n', '<D-S-e>', open_explorer, { desc = 'Open Snacks Explorer with Cmd+Shift+E' })
vim.keymap.set('n', '<leader>o', open_explorer, { desc = '[o]pen explorer' })

-- terminal
vim.keymap.set('n', '<c-`>', function() Snacks.terminal() end, { desc = 'Terminal (cwd)' })
vim.keymap.set('t', '<C-`>', '<cmd>close<cr>', { desc = 'Hide Terminal' })

-- LSP pickers
vim.keymap.set('n', 'grr', function() Snacks.picker.lsp_references() end, { desc = '[G]oto [R]eferences' })
vim.keymap.set('n', 'gri', function() Snacks.picker.lsp_implementations() end, { desc = '[G]oto [I]mplementation' })
vim.keymap.set('n', 'grd', function() Snacks.picker.lsp_definitions() end, { desc = '[G]oto [D]efinition' })
vim.keymap.set('n', 'gO', function() Snacks.picker.lsp_symbols() end, { desc = 'Open Document Symbols' })
vim.keymap.set('n', 'gW', function() Snacks.picker.lsp_workspace_symbols() end, { desc = 'Open Workspace Symbols' })
vim.keymap.set('n', 'grt', function() Snacks.picker.lsp_type_definitions() end, { desc = '[G]oto [T]ype Definition' })
