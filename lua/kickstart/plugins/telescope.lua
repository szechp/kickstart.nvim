-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function() return vim.fn.executable 'make' == 1 end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[h]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[k]eymaps' })
      vim.keymap.set('n', '<leader>.', builtin.find_files, { desc = 'find files in [.]/' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[s]elect Telescope' })
      vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = 'current [w]ord' })
      vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = 'grep (cwd)' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[d]iagnostics' })
      vim.keymap.set('n', '<leader>sp', builtin.resume, { desc = 'resume [p]revious picker' })
      vim.keymap.set('n', '<leader>sr', builtin.oldfiles, { desc = '[r]ecent Files' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[g]rep in Open Files' }) -- You may want to use a custom function for buffers
      vim.keymap.set('n', '<leader>sN', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = '[N]eovim files' })

      -- Global toggle state for including ignored + hidden files in live_grep
      _G._telescope_include_ignored = false

      -- Helper to return live_grep options with dynamic additional_args and <C-i> toggle
      local function get_live_grep_opts()
        return {
          additional_args = function()
            if _G._telescope_include_ignored then
              return { '--no-ignore', '--hidden' }
            else
              return {}
            end
          end,

          -- Keybinding inside Telescope prompt to toggle ignored visibility and reopen picker
          attach_mappings = function(_, map)
            map({ 'i', 'n' }, '<M-i>', function(prompt_bufnr)
              _G._telescope_include_ignored = not _G._telescope_include_ignored
              require('telescope.actions').close(prompt_bufnr)
              vim.schedule(function() builtin.live_grep(get_live_grep_opts()) end)
              vim.notify(
                'Telescope [live_grep]: include ignored = ' .. tostring(_G._telescope_include_ignored),
                vim.log.levels.INFO,
                { title = 'Telescope Toggle' }
              )
            end)
            return true
          end,
        }
      end

      -- Keymap to open live_grep with toggle support
      vim.keymap.set('n', '<leader>/', function() builtin.live_grep(get_live_grep_opts()) end, { desc = 'grep (cwd)' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>sb', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[b]uffer (fuzzily)' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set(
        'n',
        '<leader>s/',
        function()
          builtin.live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end,
        { desc = '[S]earch [/] in Open Files' }
      )

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
