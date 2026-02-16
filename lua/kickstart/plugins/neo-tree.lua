-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

---@module 'lazy'
---@type LazySpec
return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '<leader>o', ':Neotree reveal<CR>', desc = '[o]pen NeoTree', silent = true },
  },
  ---@module 'neo-tree'
  ---@type neotree.Config
  opts = {
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
      },
      use_libuv_file_watcher = false,
      window = {
        mappings = {
          ['<leader>o'] = 'close_window',
        },
      },
    },

    default_component_configs = {
      icon = {
        provider = function(icon, node) -- setup a custom icon provider
          local text, hl
          local mini_icons = require 'mini.icons'
          if node.type == 'file' then -- if it's a file, set the text/hl
            text, hl = mini_icons.get('file', node.name)
          elseif node.type == 'directory' then -- get directory icons
            text, hl = mini_icons.get('directory', node.name)
            -- only set the icon text if it is not expanded
            if node:is_expanded() then
              text = nil
            end
          end

          -- set the icon text/highlight only if it exists
          if text then
            icon.text = text
          end
          if hl then
            icon.highlight = hl
          end
        end,
      },
      kind_icon = {
        provider = function(icon, node)
          local mini_icons = require 'mini.icons'
          icon.text, icon.highlight = mini_icons.get('lsp', node.extra.kind.name)
        end,
      },
    },
  },
}
