return {
  {
    'olimorris/codecompanion.nvim',
    enabled = not vim.g.vscode,
    keys = {
      -- Open chat window
      {
        '<leader>ac',
        function()
          local mode = vim.fn.mode()
          if mode == 'v' or mode == 'V' or mode == '' then
            -- escape visual mode, then run with '<,'> range
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'x', false)
            vim.cmd "'<,'>CodeCompanionChat"
          else
            vim.cmd 'CodeCompanionChat'
          end
        end,
        mode = { 'n', 'v' },
        desc = 'open code companion [c]hat (contextual)',
      },
      -- Open action palette
      { '<leader>aa', '<cmd>CodeCompanionActions<cr>', desc = 'open code companion [a]ction palette' },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'github/copilot.vim',
      'ravitemer/codecompanion-history.nvim',
      -- {
      --   'Davidyz/VectorCode',
      --   version = '*', -- optional, depending on whether you're on nightly or release
      --   build = 'uv tool install vectorcode', -- optional but recommended. This keeps your CLI up-to-date.
      --   dependencies = { 'nvim-lua/plenary.nvim' },
      -- },
      {
        'MeanderingProgrammer/render-markdown.nvim',
        ft = { 'markdown', 'codecompanion' },
        -- keys = {
        --   -- Accept next word with Alt+Right
        --   { '<M-Right>', '<Plug>(copilot-accept-word)', mode = 'i', desc = 'Copilot Accept Word' },
        --   -- Accept next line with Alt+Ctrl+Right
        --   { '<M-C-Right>', '<Plug>(copilot-accept-line)', mode = 'i', desc = 'Copilot Accept Line' },
        --   -- Cycle to next suggestion with Alt+]
        --   { '<M-]>', '<Plug>(copilot-next)', mode = 'i', desc = 'Copilot Next Suggestion' },
        --   -- Cycle to previous suggestion with Alt+[
        --   { '<M-[>', '<Plug>(copilot-previous)', mode = 'i', desc = 'Copilot Previous Suggestion' },
        --   -- Dismiss suggestion
        --   { '<C-]>', '<Plug>(copilot-dismiss)', mode = 'i', desc = 'Copilot Dismiss Suggestion' },
        --   -- Request suggestion explicitly
        --   { '<M-\\>', '<Plug>(copilot-suggest)', mode = 'i', desc = 'Copilot Request Suggestion' },
        -- },
      },
    },
    config = function()
      require('codecompanion').setup {
        opts = {
          log_level = 'ERROR',
        },
        adapters = {
          ollama = function()
            return require('codecompanion.adapters').use('ollama')
          end,
          copilot = function()
            return require('codecompanion.adapters').extend('copilot', {})
          end,
          acp = {
            copilot_acp = function()
              return require('codecompanion.adapters').extend('claude_code', {
                name = 'copilot_acp',
                formatted_name = 'Copilot ACP',
                commands = {
                  default = { 'copilot', '--acp', '--silent' },
                },
                env = {},
                handlers = {
                  setup = function(self)
                    return true
                  end,
                  auth = function(self)
                    return true
                  end,
                },
              })
            end,
          },
        },
        strategies = {
          chat = {
            slash_commands = {
              ['buffer'] = {
                -- Location to the slash command in CodeCompanion
                opts = {
                  provider = 'snacks', -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks"
                },
              },
              ['fetch'] = {
                -- Location to the slash command in CodeCompanion
                opts = {
                  provider = 'snacks', -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks"
                },
              },
              ['file'] = {
                -- Location to the slash command in CodeCompanion
                opts = {
                  provider = 'snacks', -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks"
                },
              },
              ['help'] = {
                -- Location to the slash command in CodeCompanion
                opts = {
                  provider = 'snacks', -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks"
                },
              },
              ['image'] = {
                -- Location to the slash command in CodeCompanion
                opts = {
                  provider = 'snacks', -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks"
                },
              },
            },
            adapter = 'copilot_acp',
          },
          inline = {
            adapter = 'copilot',
          },
          cmd = {
            adapter = 'copilot',
          },
        },
        display = {
          chat = {
            window = {
              -- layout = 'buffer',
              opts = {
                wrap = true,
                linebreak = true,
              },
            },
            action_palette = {},
          },
          action_palette = {
            provider = 'snacks',
            opts = {
              show_default_actions = true,
              show_default_prompt_library = true,
            },
          },
        },
        extensions = {
          -- vectorcode = {
          --   opts = {
          --     add_tool = true,
          --   },
          -- },
          history = {
            enabled = true,
            opts = {
              -- Keymap to open history from chat buffer (default: gh)
              keymap = 'gh',
              -- Keymap to save the current chat manually (when auto_save is disabled)
              save_chat_keymap = 'sc',
              -- Save all chats by default (disable to save only manually using 'sc')
              auto_save = true,
              -- Number of days after which chats are automatically deleted (0 to disable)
              expiration_days = 0,
              -- Picker interface (auto resolved to a valid picker)
              picker = 'default', --- ("telescope", "snacks", "fzf-lua", or "default")
              picker_keymaps = {
                rename = { n = 'r', i = '<M-r>' },
                delete = { n = 'd', i = '<M-d>' },
                duplicate = { n = '<C-y>', i = '<C-y>' },
              },
              auto_generate_title = false,
              -- title_generation_opts = {
              --   adapter = 'ollama',
              --   model = 'qwen3-coder:latest',
              -- },
              ---Directory path to save the chats
              dir_to_save = vim.fn.stdpath 'data' .. '/codecompanion-history',
            },
          },
        },
      }
    end,
  },
}
