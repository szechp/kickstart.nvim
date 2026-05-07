-- ============================================================
-- SECTION 1: FOUNDATION
-- Core Neovim settings, leaders, options, keymaps, autocommands
-- ============================================================
do
  vim.loader.enable()

  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '
  vim.g.have_nerd_font = true

  -- [[ Options ]]
  vim.o.number = true
  vim.o.relativenumber = true
  vim.o.mouse = 'a'
  vim.o.showmode = false
  vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)
  vim.o.breakindent = true
  vim.o.undofile = true
  vim.o.ignorecase = true
  vim.o.smartcase = true
  vim.o.signcolumn = 'yes'
  vim.o.updatetime = 250
  vim.o.timeoutlen = 300
  vim.o.splitright = true
  vim.o.splitbelow = true
  vim.o.list = true
  vim.opt.listchars = { tab = '⇥ ', trail = '·', nbsp = '␣' }
  vim.o.inccommand = 'split'
  vim.o.cursorline = true
  vim.o.scrolloff = 10
  vim.o.confirm = true
  vim.o.laststatus = 3
  vim.o.wrap = false
  vim.o.cmdheight = 0
  vim.o.termguicolors = true

  -- [[ Diagnostic config ]]
  vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },
    virtual_text = true,
    virtual_lines = false,
    signs = vim.g.have_nerd_font and {
      text = {
        [vim.diagnostic.severity.ERROR] = '󰅚 ',
        [vim.diagnostic.severity.WARN] = '󰀪 ',
        [vim.diagnostic.severity.INFO] = '󰋽 ',
        [vim.diagnostic.severity.HINT] = '󰌶 ',
      },
    } or {},
    jump = { float = true },
  }

  -- [[ Basic keymaps ]]
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
  vim.keymap.set('n', '<leader>Q', ':bd<CR>', { desc = 'Close current buffer' })

  if not vim.g.vscode then
    vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
    vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
    vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
    vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
  end

  -- [[ Autocommands ]]
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank { timeout = 200 } end,
  })

  vim.api.nvim_create_autocmd('BufReadPost', {
    desc = 'Restore cursor position on file open',
    group = vim.api.nvim_create_augroup('kickstart-restore-cursor', { clear = true }),
    pattern = '*',
    callback = function()
      local line = vim.fn.line '\'"'
      if line > 1 and line <= vim.fn.line '$' then vim.cmd 'normal! g\'"' end
    end,
  })

  vim.api.nvim_create_autocmd('BufWritePre', {
    desc = 'Auto-create missing dirs when saving a file',
    group = vim.api.nvim_create_augroup('kickstart-auto-create-dir', { clear = true }),
    pattern = '*',
    callback = function()
      local dir = vim.fn.expand '<afile>:p:h'
      if vim.fn.isdirectory(dir) == 0 then vim.fn.mkdir(dir, 'p') end
    end,
  })

  -- [[ Custom navigation & selection ]]
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

  vim.keymap.set('n', '<leader>tw', function()
    vim.wo.wrap = not vim.wo.wrap
    vim.notify('Wrap: ' .. (vim.wo.wrap and 'enabled' or 'disabled'))
  end, { desc = 'line [w]rap' })

  require 'custom.yaml_nav'

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'helm' },
    callback = function()
      vim.bo.expandtab = true
      vim.bo.shiftwidth = 2
      vim.bo.softtabstop = 2
      vim.bo.tabstop = 2
      vim.bo.indentexpr = ''
    end,
  })

  -- [[ vim.ui2: centered floating cmdline ]]
  vim.schedule(function()
    local ok, ui2 = pcall(require, 'vim._core.ui2')
    if not ok then return end
    ui2.enable()

    local orig_cfg = nil
    local grp = vim.api.nvim_create_augroup('ui2-centered-cmdline', { clear = true })

    vim.api.nvim_create_autocmd('CmdlineEnter', {
      group = grp,
      callback = function()
        local win = ui2.wins and ui2.wins.cmd
        if not (win and vim.api.nvim_win_is_valid(win)) then return end
        if orig_cfg == nil then orig_cfg = vim.api.nvim_win_get_config(win) end
        local t = vim.fn.getcmdtype()
        if t == '/' or t == '?' then return end
        local width = math.floor(vim.o.columns * 0.4)
        local col = math.floor((vim.o.columns - width) / 2)
        local row = math.floor(vim.o.lines * 0.3)
        pcall(vim.api.nvim_win_set_config, win, { relative = 'editor', row = row, col = col, width = width, border = 'rounded' })
        -- blink.cmp expects (1-indexed row, 0-indexed col) pointing at the content row (skip top border)
        vim.g.ui_cmdline_pos = { row + 2, col + 1 }
      end,
    })

    vim.api.nvim_create_autocmd('CmdlineLeave', {
      group = grp,
      callback = function()
        if orig_cfg == nil then return end
        local win = ui2.wins and ui2.wins.cmd
        if win and vim.api.nvim_win_is_valid(win) then pcall(vim.api.nvim_win_set_config, win, orig_cfg) end
        orig_cfg = nil
      end,
    })
  end)

  -- [[ Scooter search integration ]]
  local scooter_term = nil

  _G.EditLineFromScooter = function(file_path, line)
    if scooter_term and scooter_term:buf_valid() then scooter_term:hide() end
    local current_path = vim.fn.expand '%:p'
    local target_path = vim.fn.fnamemodify(file_path, ':p')
    if current_path ~= target_path then vim.cmd.edit(vim.fn.fnameescape(file_path)) end
    vim.api.nvim_win_set_cursor(0, { line, 0 })
  end

  local function is_terminal_running(term)
    if not term or not term:buf_valid() then return false end
    local channel = vim.fn.getbufvar(term.buf, 'terminal_job_id')
    return channel and vim.fn.jobwait({ channel }, 0)[1] == -1
  end

  local function open_scooter()
    if is_terminal_running(scooter_term) then
      scooter_term:toggle()
    else
      scooter_term = require('snacks').terminal.open('scooter', { win = { position = 'float' } })
    end
  end

  local function open_scooter_with_text(search_text)
    if scooter_term and scooter_term:buf_valid() then scooter_term:close() end
    local escaped_text = vim.fn.shellescape(search_text:gsub('\r?\n', ' '))
    scooter_term = require('snacks').terminal.open('scooter --fixed-strings --search-text ' .. escaped_text, { win = { position = 'float' } })
  end

  vim.keymap.set('n', '<leader>sR', open_scooter, { desc = 'search and [R]eplace' })
  vim.keymap.set('v', '<leader>rR', function()
    local selection = vim.fn.getreg '"'
    vim.cmd 'normal! "ay'
    open_scooter_with_text(vim.fn.getreg 'a')
    vim.fn.setreg('"', selection)
  end, { desc = 'search and [R]eplace selected text' })

  -- [[ VSCode / Windsurf compatibility ]]
  if vim.g.vscode then
    vim.keymap.set('n', '<leader>o', function() vim.fn.VSCodeNotify 'workbench.view.explorer' end, { desc = '[o]pen file explorer' })
    vim.keymap.set('n', '<leader>ac', function() vim.fn.VSCodeNotify 'windsurf.prioritized.chat.open' end, { desc = '[a]i [c]ascade chat' })
    vim.keymap.set('n', '<leader>bd', function() vim.fn.VSCodeNotify 'workbench.action.closeActiveEditor' end, { desc = '[b]uffer [d]elete editor' })
    vim.keymap.set('n', '<leader>/', function() vim.fn.VSCodeNotify 'workbench.action.findInFiles' end, { desc = 'search in files' })
    vim.keymap.set('n', '<leader>gg', function()
      vim.fn.jobstart({
        '/opt/homebrew/bin/alacritty',
        '--title', 'lazygit',
        '--working-directory', vim.fn.getcwd(),
        '-e', 'lazygit',
      }, { detach = true })
      vim.defer_fn(function()
        vim.fn.jobstart({ '/opt/homebrew/bin/yabai', '-m', 'window', '--toggle', 'zoom-fullscreen' }, { detach = true })
      end, 250)
    end, { desc = '[g]it lazygit (Alacritty)' })
  end
end

-- ============================================================
-- SECTION 2: PLUGIN MANAGER
-- vim.pack intro and build hooks
-- See :help vim.pack, :lua vim.pack.update() to update
-- ============================================================
do
  local function run_build(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()
    if result.code ~= 0 then
      local stderr = result.stderr or ''
      local stdout = result.stdout or ''
      local output = stderr ~= '' and stderr or stdout
      if output == '' then output = 'No output from build command.' end
      vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
    end
  end

  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name = ev.data.spec.name
      local kind = ev.data.kind
      if kind ~= 'install' and kind ~= 'update' then return end

      if name == 'LuaSnip' then
        if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then run_build(name, { 'make', 'install_jsregexp' }, ev.data.path) end
        return
      end

      if name == 'nvim-treesitter' then
        if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
        vim.cmd 'TSUpdate'
        return
      end
    end,
  })
end

---@param repo string
---@return string
local function gh(repo) return 'https://github.com/' .. repo end

-- ============================================================
-- SECTION 3: UI / CORE UX PLUGINS
-- which-key, mini.nvim, colorscheme, todo-comments, gitsigns
-- ============================================================
do
  vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
  require('guess-indent').setup {}

  if vim.g.have_nerd_font then vim.pack.add { gh 'nvim-tree/nvim-web-devicons' } end

  vim.pack.add { gh 'folke/which-key.nvim' }
  if not vim.g.vscode then
    require('which-key').setup {
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },
      spec = {
        { '<leader>s', group = '[s]earch', mode = { 'n', 'v' } },
        { '<leader>g', group = '[g]it' },
        { '<leader>b', group = '[b]uffer' },
        { '<leader>a', group = '[a]i tools' },
        { '<leader>t', group = '[t]oggle' },
        { '<leader>gh', group = '[h]unk', mode = { 'n', 'v' } },
        { '<leader>gl', group = '[l]ine' },
        { '<leader>gb', group = '[b]uffer' },
        { 'gs', group = '[s]urround', mode = { 'n', 'v' } },
        { 'gr', group = 'LSP Actions', mode = { 'n' } },
      },
    }
  end

  vim.pack.add { gh 'folke/todo-comments.nvim' }
  require('todo-comments').setup { signs = false }

  -- mini.nvim suite
  vim.pack.add { gh 'nvim-mini/mini.nvim' }

  require('mini.ai').setup {
    mappings = { around_next = 'aa', inside_next = 'ii' },
    n_lines = 500,
  }

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

  require('mini.pairs').setup()
  require('mini.indentscope').setup { draw = { animation = require('mini.indentscope').gen_animation.none() } }

  require('mini.move').setup {
    options = { reindent_linewise = true },
    mappings = {
      left = '<M-Left>',
      right = '<M-Right>',
      down = '<M-Down>',
      up = '<M-Up>',
      line_left = '<M-Left>',
      line_right = '<M-Right>',
      line_down = '<M-Down>',
      line_up = '<M-Up>',
    },
  }

  if not vim.g.vscode then
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
      plugins = { default = false, ['echasnovski/mini.nvim'] = true },
    }

    require('mini.icons').setup()
    require('mini.diff').setup { source = require('mini.diff').gen_source.none() }
    require('mini.tabline').setup()

    local statusline = require 'mini.statusline'
    statusline.setup { use_icons = vim.g.have_nerd_font }
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function() return '%2l:%-2v' end

    require('mini.bufremove').setup()
    vim.keymap.set('n', '<leader>bd', function() require('mini.bufremove').delete(0, false) end, { desc = '[d]elete' })
  end

  require 'kickstart.plugins.gitsigns'
end

-- ============================================================
-- SECTION 4: LSP
-- lazydev, fidget, nvim-lspconfig, mason
-- ============================================================
do
  vim.pack.add { gh 'folke/lazydev.nvim' }
  require('lazydev').setup {
    library = { { path = '${3rd}/luv/library', words = { 'vim%.uv' } } },
  }

  vim.pack.add { gh 'j-hui/fidget.nvim' }
  require('fidget').setup {}

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
      map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
      map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
      map('<leader>td', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, '[T]oggle [D]iagnostics')

      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method('textDocument/documentHighlight', event.buf) then
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

      if client and client:supports_method('textDocument/inlayHint', event.buf) then
        map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
      end
    end,
  })

  ---@class LspServersConfig
  ---@field mason table<string, vim.lsp.Config>
  ---@field others table<string, vim.lsp.Config>
  local servers = {
    mason = {
      jsonls = {},
      stylua = {},
      lua_ls = {
        on_init = function(client)
          client.server_capabilities.documentFormattingProvider = false
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
          end
          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = { version = 'LuaJIT', path = { 'lua/?.lua', 'lua/?/init.lua' } },
            workspace = {
              checkThirdParty = false,
              library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
                '${3rd}/luv/library',
                '${3rd}/busted/library',
              }),
            },
          })
        end,
        settings = { Lua = { format = { enable = false } } },
      },
    },
    others = {
      yamlls = {
        cmd = { vim.fn.stdpath 'config' .. '/yaml-schema-router', '--lsp-path', 'yaml-language-server' },
      },
      helm_ls = {
        settings = {
          ['helm-ls'] = {
            yamlls = { path = vim.fn.stdpath 'config' .. '/yaml-schema-router' },
          },
        },
      },
      tofu_ls = {
        cmd = { 'tofu-ls', 'serve' },
        filetypes = { 'terraform', 'terraform-vars' },
        root_markers = { '.terraform', '.git' },
      },
      copilot = {},
    },
  }

  vim.pack.add {
    gh 'neovim/nvim-lspconfig',
    gh 'mason-org/mason.nvim',
    gh 'mason-org/mason-lspconfig.nvim',
    gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
  }

  require('mason').setup {}
  require('mason-tool-installer').setup { ensure_installed = vim.tbl_keys(servers.mason or {}) }

  for server, config in pairs(vim.tbl_extend('keep', servers.mason, servers.others)) do
    if not vim.tbl_isempty(config) then vim.lsp.config(server, config) end
  end

  require('mason-lspconfig').setup {
    ensure_installed = {},
    automatic_enable = true,
  }

  if not vim.tbl_isempty(servers.others) then vim.lsp.enable(vim.tbl_keys(servers.others)) end
end

-- ============================================================
-- SECTION 5: FORMATTING
-- conform.nvim
-- ============================================================
do
  vim.pack.add { gh 'stevearc/conform.nvim' }
  require('conform').setup {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- All filetypes opt-out by default; format manually with <leader>f
      local disable_filetypes = setmetatable({}, { __index = function() return true end })
      if disable_filetypes[vim.bo[bufnr].filetype] then return nil end
      return nil
    end,
    default_format_opts = { lsp_format = 'fallback' },
    formatters_by_ft = {},
  }

  vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer' })
end

-- ============================================================
-- SECTION 6: AUTOCOMPLETE & SNIPPETS
-- LuaSnip, blink.cmp
-- ============================================================
do
  vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
  require('luasnip').setup {}

  vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
  require('blink.cmp').setup {
    keymap = {
      preset = 'enter',
      ['<C-j>'] = { 'select_next', 'fallback' },
      ['<C-k>'] = { 'select_prev', 'fallback' },
    },
    appearance = { nerd_font_variant = 'mono' },
    completion = {
      accept = { dot_repeat = false },
      documentation = { auto_show = true, auto_show_delay_ms = 500 },
      list = { selection = { preselect = false } },
    },
    cmdline = {
      completion = {
        list = { selection = { preselect = false } },
        menu = { auto_show = true },
      },
      keymap = {
        preset = 'default',
        ['<Right>'] = { 'show', 'accept', 'fallback' },
      },
      sources = function()
        local type = vim.fn.getcmdtype()
        if type == '/' or type == '?' then return {} end
        if type == ':' or type == '@' then return { 'cmdline' } end
        return {}
      end,
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'lazydev', 'buffer' },
      per_filetype = { codecompanion = { 'codecompanion' } },
      providers = {
        lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        buffer = {
          score_offset = -100,
          enabled = function() return vim.tbl_contains({ 'markdown', 'text' }, vim.bo.filetype) end,
        },
      },
    },
    snippets = { preset = 'luasnip' },
    fuzzy = { implementation = 'lua' },
    signature = { enabled = true },
  }
end

-- ============================================================
-- SECTION 7: TREESITTER
-- Parser installation, syntax highlighting, indentation
-- ============================================================
do
  vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' } }

  local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'regex' }
  require('nvim-treesitter').install(parsers)

  local function treesitter_try_attach(buf, language)
    if not vim.treesitter.language.add(language) then return end
    vim.treesitter.start(buf, language)
    local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil
    if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
  end

  local available_parsers = require('nvim-treesitter').get_available()
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local buf, filetype = args.buf, args.match
      local language = vim.treesitter.language.get_lang(filetype)
      if not language then return end
      local installed_parsers = require('nvim-treesitter').get_installed 'parsers'
      if vim.tbl_contains(installed_parsers, language) then
        treesitter_try_attach(buf, language)
      elseif vim.tbl_contains(available_parsers, language) then
        require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
      else
        treesitter_try_attach(buf, language)
      end
    end,
  })
end

-- ============================================================
-- SECTION 8: CUSTOM PLUGINS
-- lua/custom/plugins/*.lua — each file calls vim.pack.add + setup
-- ============================================================
do
  require 'custom.plugins'

  -- Optional kickstart extras (uncomment to enable):
  -- require 'kickstart.plugins.debug'
  -- require 'kickstart.plugins.indent_line'
  -- require 'kickstart.plugins.lint'
  -- require 'kickstart.plugins.autopairs'
  -- require 'kickstart.plugins.neo-tree'
end

-- vim: ts=2 sts=2 sw=2 et
