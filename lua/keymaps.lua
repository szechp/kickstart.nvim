-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'open diagnostic [q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Close current buffer
vim.keymap.set('n', '<leader>Q', ':bd<CR>', { desc = 'Close current buffer' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank { timeout = 200 } end,
})

-- Restore cursor position on file open
vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Restore cursor position on file open',
  group = vim.api.nvim_create_augroup('kickstart-restore-cursor', { clear = true }),
  pattern = '*',
  callback = function()
    local line = vim.fn.line '\'"'
    if line > 1 and line <= vim.fn.line '$' then
      vim.cmd 'normal! g\'"'
    end
  end,
})

-- auto-create missing dirs when saving a file
vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Auto-create missing dirs when saving a file',
  group = vim.api.nvim_create_augroup('kickstart-auto-create-dir', { clear = true }),
  pattern = '*',
  callback = function()
    local dir = vim.fn.expand '<afile>:p:h'
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
    end
  end,
})

-- [[ my custom stuff ]]

vim.api.nvim_set_keymap('n', '<C-a>', 'ggVG', { noremap = true, silent = true, desc = 'Select all' })

vim.api.nvim_set_keymap('x', '<S-Up>', 'k', { noremap = true, silent = true, desc = 'Extend visual selection up' })
vim.api.nvim_set_keymap('x', '<S-Down>', 'j', { noremap = true, silent = true, desc = 'Extend visual selection down' })
vim.api.nvim_set_keymap('n', '<S-Up>', '<Esc>Vk', { noremap = true, silent = true, desc = 'Start visual selection and move up' })
vim.api.nvim_set_keymap('n', '<S-Down>', '<Esc>Vj', { noremap = true, silent = true, desc = 'Start visual selection and move down' })
vim.api.nvim_set_keymap('n', '<S-Left>', 'v', { noremap = true, silent = true, desc = 'Enter visual mode and select left' })
vim.api.nvim_set_keymap('n', '<S-Right>', 'v', { noremap = true, silent = true, desc = 'Enter visual mode and select right' })

vim.api.nvim_set_keymap('i', '<C-A>', '<HOME>', { noremap = true, silent = true, desc = 'Jump to first char in line' })
vim.api.nvim_set_keymap('i', '<C-E>', '<END>', { noremap = true, silent = true, desc = 'Jump to last char in line' })

vim.api.nvim_set_keymap('n', '<C-Left>', '<C-w>h', { noremap = true, silent = true, desc = 'Move to left split' })
vim.api.nvim_set_keymap('n', '<C-Right>', '<C-w>l', { noremap = true, silent = true, desc = 'Move to right split' })

vim.api.nvim_set_keymap('n', 'dx', '<Cmd>normal "_dd<CR>', { noremap = true, silent = true, desc = 'Delete line without yanking' })
vim.api.nvim_set_keymap('v', 'x', '"_d', { noremap = true, silent = true, desc = 'Delete selection without yanking' })

-- close neotree when opening debug
-- vim.keymap.set('n', "<leader>du", function() vim.cmd.Neotree('toggle') require("dapui").toggle({ }) end)
-- vim.keymap.set('n', "<leader>dc", function() vim.cmd.Neotree('toggle')  require("dap").continue() end)

vim.keymap.set('n', '<leader>tw', function()
  vim.wo.wrap = not vim.wo.wrap
  vim.notify('Wrap: ' .. (vim.wo.wrap and 'enabled' or 'disabled'))
end, { desc = 'line [w]rap' })

-- custom autocmds
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'helm' },
  callback = function()
    -- Force YAML-like spaces
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.tabstop = 2
    -- If indentexpr is doing weird stuff, clear it
    vim.bo.indentexpr = ''
  end,
})

-- scooter snacks integration
local scooter_term = nil

-- Called by scooter to open the selected file at the correct line from the scooter search list
_G.EditLineFromScooter = function(file_path, line)
  if scooter_term and scooter_term:buf_valid() then
    scooter_term:hide()
  end

  local current_path = vim.fn.expand '%:p'
  local target_path = vim.fn.fnamemodify(file_path, ':p')

  if current_path ~= target_path then
    vim.cmd.edit(vim.fn.fnameescape(file_path))
  end

  vim.api.nvim_win_set_cursor(0, { line, 0 })
end

local function is_terminal_running(term)
  if not term or not term:buf_valid() then
    return false
  end
  local channel = vim.fn.getbufvar(term.buf, 'terminal_job_id')
  return channel and vim.fn.jobwait({ channel }, 0)[1] == -1
end

local function open_scooter()
  if is_terminal_running(scooter_term) then
    scooter_term:toggle()
  else
    scooter_term = require('snacks').terminal.open('scooter', {
      win = { position = 'float' },
    })
  end
end

local function open_scooter_with_text(search_text)
  if scooter_term and scooter_term:buf_valid() then
    scooter_term:close()
  end

  local escaped_text = vim.fn.shellescape(search_text:gsub('\r?\n', ' '))
  scooter_term = require('snacks').terminal.open('scooter --fixed-strings --search-text ' .. escaped_text, {
    win = { position = 'float' },
  })
end

vim.keymap.set('n', '<leader>sR', open_scooter, { desc = 'search and [R]eplace' })
vim.keymap.set('v', '<leader>rR', function()
  local selection = vim.fn.getreg '"'
  vim.cmd 'normal! "ay'
  open_scooter_with_text(vim.fn.getreg 'a')
  vim.fn.setreg('"', selection)
end, { desc = 'search and [R]eplace selected text' })

-- vscode specific commands
if vim.g.vscode then
  vim.keymap.set('n', '<leader>o', function() vim.fn.VSCodeNotify 'workbench.view.explorer' end, { desc = '[o]pen file explorer' })
  vim.keymap.set('n', '<leader>gg', function()
    -- Call the LazyGit toggle command from the extension
    vim.fn.VSCodeNotify('lazygit-vscode.toggle')
  end, { desc = 'Toggle LazyGit (VSCode extension)' })
end

-- vim: ts=2 sts=2 sw=2 et
