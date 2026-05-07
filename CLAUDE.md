# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal Neovim configuration built on top of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). Plugin management is handled by **lazy.nvim**.

## Lua formatting

All Lua must be formatted with **stylua** (configured in `.stylua.toml`):
- Column width: 160, indent: 2 spaces, single-quote preference, collapse simple statements: always

Format manually inside Neovim with `<leader>f` (conform.nvim). There is no format-on-save by default.

## Plugin management commands (inside Neovim)

```
:Lazy sync      # install / update / clean plugins
:Lazy update    # update all
:Mason          # manage LSP servers / formatters
:checkhealth    # verify setup
```

## Architecture

### File layout

- **`init.lua`** — monolithic main config (~1 160 lines). Sections in order:
  1. Leader key + vim options
  2. Core keymaps (diagnostics, splits, terminal, selection)
  3. Autocommands (yank highlight, cursor restore, auto-mkdir, filetype tweaks)
  4. Scooter integration (floating search/replace terminal)
  5. VSCode/Windsurf conditional keymaps
  6. All lazy.nvim plugin specs (inline + imports from `lua/custom/plugins/`)

- **`lua/custom/plugins/`** — one file per plugin for anything added on top of kickstart. Drop a new `<name>.lua` here; lazy.nvim picks it up automatically via the `{ import = "custom.plugins" }` spec at the bottom of `init.lua`.

- **`lua/kickstart/plugins/`** — optional kickstart extras (gitsigns, neo-tree, debug, lint, autopairs, indent_line). Most are disabled unless uncommented in `init.lua`.

- **`lua/custom/yaml_nav.lua`** — custom `%` key for YAML/Helm files; uses Treesitter to jump between key-value pairs.

- **`yaml-schema-router`** + **`update-yaml-schema-router.sh`** — compiled binary that routes YAML files to the correct JSON schema for `yamlls`. Run the shell script to update the binary.

### Plugin stack highlights

| Layer | Plugin(s) |
|---|---|
| Fuzzy finding | snacks.nvim (replaces Telescope) |
| LSP | mason + mason-lspconfig + nvim-lspconfig |
| Completion | blink.cmp + LuaSnip |
| Formatting | conform.nvim |
| Git UI | snacks.nvim lazygit, gitsigns |
| Copilot | copilot.lua + sidekick.lua (CLI wrapper) |
| UI suite | mini.nvim (statusline, tabline, surround, move, ai, pairs, icons, …) |
| Colorscheme | mini.base16 (custom dark palette, defined inline in init.lua) |
| Diagnostics | tiny-inline-diagnostic.nvim (inline virtual text) |
| Folding | nvim-origami (auto-folds imports) |
| Command UI | noice.nvim |

### LSP servers

Configured servers and how they are installed:

- **Mason-managed**: `lua_ls`, `jsonls`, `stylua`
- **External / system**: `yamlls` (with yaml-schema-router), `helm_ls`, `tofu_ls`, `copilot`

LSP keymaps live in the `LspAttach` autocommand in `init.lua` (around line 550). Snacks picker provides `grr`/`gri`/`grd`/`gO`/`gW`/`grt`.

### Adding a new plugin

1. Create `lua/custom/plugins/<plugin-name>.lua` returning a lazy.nvim spec table.
2. Lazy picks it up on next start — no registration needed.
3. Format the file with stylua before committing.

### Scooter (search/replace)

`<leader>sR` opens a floating Scooter terminal. Results call back into Neovim via `_G.EditLineFromScooter()`, which jumps the cursor to the matched file/line. The integration code is in `init.lua` around lines 246–300.

### VSCode compatibility

When `vim.g.vscode` is set, most UI plugins are skipped and a small set of VSCode-specific keymaps is loaded (lazygit via Alacritty + yabai). Guard any new plugin with `cond = not vim.g.vscode` if it is UI-only.
