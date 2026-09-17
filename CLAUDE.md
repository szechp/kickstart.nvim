# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal Neovim configuration forked from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). Plugin management uses the native **`vim.pack`** (Neovim 0.12+) — there is no lazy.nvim anymore. The lockfile is `nvim-pack-lock.json` (`lazy-lock.json` is a stale leftover).

## Lua formatting

All Lua must be formatted with **stylua** (configured in `.stylua.toml`):
- Column width: 160, indent: 2 spaces, single-quote preference, collapse simple statements: always

Format manually inside Neovim with `<leader>f` (conform.nvim). There is no format-on-save by default.

## Plugin management commands (inside Neovim)

```
:lua vim.pack.update()   # update all plugins
:lua vim.pack.del('x')   # remove a plugin
:Mason                   # manage LSP servers / formatters
:checkhealth             # verify setup
```

Build hooks (LuaSnip `make install_jsregexp`, treesitter `TSUpdate`) run via a `PackChanged` autocmd in `init.lua` (SECTION 2).

## Architecture

### File layout

- **`init.lua`** — main config (~640 lines), organized into numbered sections:
  1. Foundation (leaders, options, core keymaps, autocommands, Scooter integration, VSCode keymaps)
  2. Plugin manager (`PackChanged` build hooks)
  3. UI / core UX plugins (which-key, mini.nvim suite, colorscheme, todo-comments, gitsigns)
  4. LSP (lazydev, fidget, lspconfig, mason, server configs)
  5. Formatting (conform.nvim)
  6. Autocomplete & snippets (LuaSnip, blink.cmp)
  7. Treesitter
  8. Custom plugins + optional kickstart extras

- **`lua/custom/plugins/`** — one file per plugin added on top of kickstart. Files are **not** lazy.nvim specs: each file directly calls `vim.pack.add` + `setup()`. `lua/custom/plugins/init.lua` auto-requires every `*.lua` in the directory via `vim.fs.dir` — **load order is unspecified**, so keep interdependent plugins in one file.

- **`lua/kickstart/plugins/`** — optional kickstart extras (neo-tree, debug, lint, autopairs, indent_line), enabled by uncommenting their `require` in SECTION 8. Exception: **`gitsigns.lua` is active** — loaded at `init.lua:385` with custom `<leader>gh*` / `<leader>gb*` / `<leader>gl*` hunk keymaps (`]c`/`[c` to navigate, `ih` text object).

- **`lua/custom/yaml_nav.lua`** — custom `%` key for YAML/Helm files; uses Treesitter to jump between key-value pairs.

- **`yaml-schema-router`** + **`update-yaml-schema-router.sh`** — compiled binary that routes YAML files to the correct JSON schema for `yamlls`. Run the shell script to update the binary.

### Plugin stack highlights

| Layer | Plugin(s) |
|---|---|
| Fuzzy finding / explorer / git UI | snacks.nvim (picker, lazygit, terminal, notifier, gitbrowse) |
| LSP | mason + mason-lspconfig + mason-tool-installer + nvim-lspconfig |
| Completion | blink.cmp + LuaSnip |
| Formatting | conform.nvim |
| Git hunks | gitsigns (via `lua/kickstart/plugins/gitsigns.lua`) |
| AI | copilot.lua + sidekick.nvim (CLI wrapper for `copilot` and `devin`) |
| UI suite | mini.nvim (statusline, tabline, surround, move, ai, pairs, icons, indentscope, bufremove, diff, …) |
| Colorscheme | mini.base16 (custom dark palette, defined inline in init.lua) |
| Motions / UX | flash.nvim, hardtime.nvim, sticky-header, statuscol, colorizer, rainbow-delimiters |
| Folding | nvim-origami (auto-folds imports) |

### LSP servers

Configured in SECTION 4 of `init.lua` as a `servers` table with `mason` and `others` subtables:

- **Mason-managed** (`servers.mason`): `lua_ls`, `jsonls`, `stylua`
- **External / system** (`servers.others`): `yamlls` (via yaml-schema-router), `helm_ls`, `tofu_ls`, `copilot`

LSP keymaps live in the `LspAttach` autocommand (`init.lua` ~line 401). Snacks picker provides `grr`/`gri`/`grd`/`gO`/`gW`/`grt`. The lua_ls workspace library uses `vim.list_extend` (not `tbl_extend` — that corrupts list paths).

### Adding a new plugin

1. Create `lua/custom/plugins/<plugin-name>.lua`.
2. If it's UI-only, start the file with `if vim.g.vscode then return end`.
3. Call `vim.pack.add { 'https://github.com/<owner>/<repo>' }` (or a `{ src = ..., version = ... }` spec), then the plugin's `setup()`.
4. The loader picks it up on next start — no registration needed.
5. Format the file with stylua before committing.

### Scooter (search/replace)

`<leader>sR` opens Scooter in a floating snacks terminal. Results call back into Neovim via `_G.EditLineFromScooter()`, which jumps the cursor to the matched file/line. The integration code is in `init.lua` SECTION 1 (~lines 178–236).

### VSCode compatibility

When `vim.g.vscode` is set, most UI plugins are skipped and a small set of VSCode-specific keymaps is loaded (lazygit via kitty + yabai). Guard UI-only plugin files with `if vim.g.vscode then return end` at the top; guard inline blocks with `if not vim.g.vscode then`.

### Merging upstream

This fork tracks `nvim-lua/kickstart.nvim` as `upstream`. Recurring conflict zones in `init.lua`: the gitsigns block (upstream inlines it; this fork keeps `lua/kickstart/plugins/gitsigns.lua` — decline upstream's inline copy) and the LSP servers block (this fork's mason/others split; keep it, but port upstream fixes like the lua_ls library-path fix).
