-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.o.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- Enable break indent
vim.o.breakindent = true

-- Enable undo/redo changes even after closing and reopening a file
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-guide-options`
vim.o.list = true
vim.opt.listchars = { tab = '⇥ ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- make statusline global, not per window
vim.o.laststatus = 3

-- Disable line wrapping
vim.o.wrap = false

-- Highlight max chars per line
-- vim.o.colorcolumn = '120'

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic Config & Keymaps
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
  virtual_text = true,
  virtual_lines = false,
  jump = { float = true },
}


vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

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

-- [[ my custom stuff ]]
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

vim.keymap.set('n', '<C-a>', 'ggVG', { desc = 'Select all' })

vim.keymap.set('x', '<S-Up>', 'k', { desc = 'Extend visual selection up' })
vim.keymap.set('x', '<S-Down>', 'j', { desc = 'Extend visual selection down' })
vim.keymap.set('n', '<S-Up>', '<Esc>Vk', { desc = 'Start visual selection and move up' })
vim.keymap.set('n', '<S-Down>', '<Esc>Vj', { desc = 'Start visual selection and move down' })
vim.keymap.set('n', '<S-Left>', 'v', { desc = 'Enter visual mode and select left' })
vim.keymap.set('n', '<S-Right>', 'v', { desc = 'Enter visual mode and select right' })

vim.keymap.set('i', '<C-A>', '<HOME>', { desc = 'Jump to first char in line' })
vim.keymap.set('i', '<C-E>', '<END>', { desc = 'Jump to last char in line' })

vim.keymap.set('n', '<C-Left>', '<C-w>h', { desc = 'Move to left split' })
vim.keymap.set('n', '<C-Right>', '<C-w>l', { desc = 'Move to right split' })

vim.keymap.set('i', '<M-Left>', '<C-o>b', { desc = 'Jump word left in insert mode' })
vim.keymap.set('i', '<M-Right>', function()
  local ok, suggestion = pcall(vim.fn['copilot#GetDisplayedSuggestion'])
  if ok and suggestion and suggestion.text and suggestion.text ~= '' then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Plug>(copilot-accept-word)', true, true, true), 'm', false)
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<S-Right>', true, true, true), 'n', false)
  end
end, { desc = 'Copilot accept word or jump word right' })

vim.keymap.set('n', 'dx', '<Cmd>normal "_dd<CR>', { desc = 'Delete line without yanking' })
vim.keymap.set('v', 'x', '"_d', { desc = 'Delete selection without yanking' })

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
    vim.fn.VSCodeNotify 'lazygit-vscode.toggle'
  end, { desc = 'Toggle LazyGit (VSCode extension)' })
end

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  { 'NMAC427/guess-indent.nvim', opts = {} }, -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to automatically pass options to a plugin's `setup()` function, forcing the plugin to be loaded.
  --

  -- Alternatively, use `config = function() ... end` for full control over the configuration.
  -- If you prefer to call `setup` explicitly, use:
  --    {
  --        'lewis6991/gitsigns.nvim',
  --        config = function()
  --            require('gitsigns').setup({
  --                -- Your gitsigns configuration here
  --            })
  --        end,
  --    }
  --
  -- For plugins written in VimScript, use `init = function() ... end` to set
  -- configuration options, usually in the format `vim.g.*`. This can also
  -- contain conditionals or any other setup logic you need for the plugin.
  --
  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`.
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  -- { -- Adds git related signs to the gutter, as well as utilities for managing changes
  --   'lewis6991/gitsigns.nvim',
  --   ---@module 'gitsigns'
  --   ---@type Gitsigns.Config
  --   ---@diagnostic disable-next-line: missing-fields
  --   opts = {
  --     signs = {
  --       add = { text = '+' }, ---@diagnostic disable-line: missing-fields
  --       change = { text = '~' }, ---@diagnostic disable-line: missing-fields
  --       delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
  --       topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
  --       changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
  --     },
  --   },
  -- },

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `opts` key (recommended), the configuration runs
  -- after the plugin has been loaded as `require(MODULE).setup(opts)`.

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter',
    ---@module 'which-key'
    ---@type wk.Opts
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.o.timeoutlen
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[s]earch', mode = { 'n', 'v' } },
        { '<leader>g', group = '[g]it' },
        { '<leader>b', group = '[b]uffer' },
        { '<leader>a', group = '[a]i tools' },
        { '<leader>t', group = '[t]oggle' },
        { '<leader>gh', group = '[h]unk', mode = { 'n', 'v' } },
        { '<leader>gl', group = '[l]ine' },
        { '<leader>gb', group = '[b]buffer' },
        { 'gs', group = '[s]urround', mode = { 'n', 'v' } },
        { 'gr', group = 'LSP Actions', mode = { 'n' } },
      },
    },
  },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    ---@module 'lazydev'
    ---@type lazydev.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      {
        'mason-org/mason.nvim',
        ---@module 'mason.settings'
        ---@type MasonSettings
        ---@diagnostic disable-next-line: missing-fields
        opts = {},
      },
      -- Maps LSP server names between nvim-lspconfig and Mason package names.
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Toggle to show/hide diagnostic messages
          map('<leader>td', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, '[T]oggle [D]iagnostics')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --  See `:help lsp-config` for information about keys and how to configure
      ---@type table<string, vim.lsp.Config>
      local servers = {
        --  Add any additional override configuration in any of the following tables. Available keys are:
        --  - cmd (table): Override the default command used to start the server
        --  - filetypes (table): Override the default list of associated filetypes for the server
        --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
        --  - settings (table): Override the default settings passed when initializing the server.
        --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
        --
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- ts_ls = {},

        yamlls = {
          cmd = { vim.fn.stdpath 'config' .. '/yaml-schema-router', '--lsp-path', 'yaml-language-server' },
        },
        helm_ls = {
          settings = {
            ['helm-ls'] = {
              yamlls = {
                path = vim.fn.stdpath 'config' .. '/yaml-schema-router',
              },
            },
          },
        },
        jsonls = {},

        -- terraformls = {},
        tofu_ls = {
          cmd = { 'tofu-ls', 'serve' },
          filetypes = { 'terraform', 'terraform-vars' },
          root_markers = { '.terraform', '.git' },
        },

        copilot = {},

        stylua = {}, -- Used to format Lua code

        -- Special Lua Config, as recommended by neovim help docs
        lua_ls = {
          on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
              runtime = {
                version = 'LuaJIT',
                path = { 'lua/?.lua', 'lua/?/init.lua' },
              },
              workspace = {
                checkThirdParty = false,
                library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
                  '${3rd}/luv/library',
                  '${3rd}/busted/library',
                }),
              },
            })
          end,
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      --
      -- `mason` had to be setup earlier: to configure its options see the
      -- `dependencies` table for `nvim-lspconfig` above.
      --
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        -- You can add other tools here that you want Mason to install
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      for name, server in pairs(servers) do
        vim.lsp.config(name, server)
        vim.lsp.enable(name)
      end
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function() require('conform').format { async = true, lsp_format = 'fallback' } end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    ---@module 'conform'
    ---@type conform.setupOpts
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = setmetatable({}, {
          __index = function()
            return true -- returns tru for all filetypes and effectively disables autoformat
          end,
        })
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },

  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    enabled = not vim.g.vscode,
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'enter',
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback' },

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        accept = {
          dot_repeat = false,
        },
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
        list = {
          selection = {
            preselect = false,
          },
        },
      },

      cmdline = {
        completion = {
          list = {
            selection = { preselect = false },
          },
          menu = { auto_show = true },
        },
        keymap = {
          preset = 'default',
          ['<Right>'] = { 'show', 'accept', 'fallback' },
          -- ['<down>'] = { 'select_next' }
          -- ['<CR>'] = { 'accept_and_enter', 'fallback' },
        },
        sources = function()
          local type = vim.fn.getcmdtype()
          -- Search forward and backward
          if type == '/' or type == '?' then
            return {}
          end
          -- Commands
          if type == ':' or type == '@' then
            return { 'cmdline' }
          end
          return {}
        end,
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev', 'buffer' },
        per_filetype = {
          codecompanion = { 'codecompanion' },
        },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
          buffer = {
            -- Make buffer compeletions appear at the end.
            score_offset = -100,
            enabled = function()
              -- Filetypes for which buffer completions are enabled; add filetypes to extend:
              local enabled_filetypes = {
                'markdown',
                'text',
              }
              local filetype = vim.bo.filetype
              return vim.tbl_contains(enabled_filetypes, filetype)
            end,
          },
        },
      },

      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'lua' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },

  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ---@module 'todo-comments'
    ---@type TodoOptions
    ---@diagnostic disable-next-line: missing-fields
    opts = { signs = false },
  },

  { -- Collection of various small independent plugins/modules
    'nvim-mini/mini.nvim',
    lazy = false,
    keys = {
      { '<M-Up>', function() require('mini.move').move_selection 'up' end, mode = 'x', desc = 'MiniMove selection up' },
      { '<M-Down>', function() require('mini.move').move_selection 'down' end, mode = 'x', desc = 'MiniMove selection down' },
      { '<M-Left>', function() require('mini.move').move_selection 'left' end, mode = 'x', desc = 'MiniMove selection left' },
      { '<M-Right>', function() require('mini.move').move_selection 'right' end, mode = 'x', desc = 'MiniMove selection right' },
      { '<M-Up>', function() require('mini.move').move_line 'up' end, mode = 'n', desc = 'MiniMove line up' },
      { '<M-Down>', function() require('mini.move').move_line 'down' end, mode = 'n', desc = 'MiniMove line down' },
      { '<M-Left>', function() require('mini.move').move_line 'left' end, mode = 'n', desc = 'MiniMove line left' },
      { '<M-Right>', function() require('mini.move').move_line 'right' end, mode = 'n', desc = 'MiniMove line right' },
    },
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }
      require('mini.base16').setup {
        palette = {
          base00 = '#16181a',
          base01 = '#1e2124',
          base02 = '#3c4048',
          base03 = '#7b8496',
          base04 = '#7b8496',
          base05 = '#ffffff',
          base06 = '#16181a',
          base07 = '#ffffff',
          base08 = '#ff6e5e',
          base09 = '#ffbd5e',
          base0A = '#f1ff5e',
          base0B = '#5eff6c',
          base0C = '#5ef1ff',
          base0D = '#5ea1ff',
          base0E = '#bd5eff',
          base0F = '#ff5ef1',
        },
        use_cterm = true,
        plugins = {
          default = false,
          ['echasnovski/mini.nvim'] = true,
        },
      }

      require('mini.icons').setup()
      require('mini.diff').setup {
        source = require('mini.diff').gen_source.none(),
      }
      require('mini.tabline').setup()

      require('mini.pairs').setup()
      require('mini.indentscope').setup {
        draw = {
          animation = require('mini.indentscope').gen_animation.none(),
        },
      }
      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup {
        mappings = {
          add = 'gsa',
          delete = 'gsd',
          find = 'gsf',
          find_left = 'gsF',
          highlight = 'gsh',
          replace = 'gsr',
          update_n_lines = 'gsn',
        },
      }

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function() return '%2l:%-2v' end

      require('mini.bufremove').setup()

      require('mini.move').setup {
        -- Options which control moving behavior
        options = {
          -- Automatically reindent selection during linewise vertical move
          reindent_linewise = true,
        },
      }

      vim.keymap.set('n', '<leader>bd', function() require('mini.bufremove').delete(0, false) end, { desc = '[d]elete' })
      -- ... and there is more!
      --  Check out: https://github.com/nvim-mini/mini.nvim
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter-intro`
    config = function()
      local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'regex' }
      require('nvim-treesitter').install(parsers)
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match

          local language = vim.treesitter.language.get_lang(filetype)
          if not language then return end

          -- check if parser exists and load it
          if not vim.treesitter.language.add(language) then return end
          -- enables syntax highlighting and other treesitter features
          vim.treesitter.start(buf, language)

          -- enables treesitter based folds
          -- for more info on folds see `:help folds`
          -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          -- vim.wo.foldmethod = 'expr'

          -- enables treesitter based indentation
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  { import = 'custom.plugins' },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
