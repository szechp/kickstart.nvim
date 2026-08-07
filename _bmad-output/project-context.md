---
project_name: 'nvim'
user_name: 'user'
date: '2026-08-07'
sections_completed: ['technology_stack', 'language_rules', 'framework_rules', 'workflow_rules', 'anti_patterns']
status: 'complete'
rule_count: 15
optimized_for_llm: true
---

# Project Context for AI Agents

_This file contains critical rules and patterns that AI agents must follow when implementing code in this project. Focus on unobvious details that agents might otherwise miss._

---

## Technology Stack & Versions

- Base: [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) — this config extends it; check upstream when patterns look unfamiliar or when reconciling upstream updates
- Neovim (Lua config), plugin manager: lazy.nvim
- Formatter: stylua (via `.stylua.toml`), manual trigger only (`<leader>f` via conform.nvim) — no format-on-save
- LSP: mason + mason-lspconfig + nvim-lspconfig
  - Mason-managed: `lua_ls`, `jsonls`
  - External/system (not via Mason): `yamlls` (+ custom `yaml-schema-router`), `helm_ls`, `tofu_ls`, `copilot`
- Completion: blink.cmp + LuaSnip
- Key UI: snacks.nvim (fuzzy finder, replaces Telescope; lazygit), mini.nvim suite, noice.nvim, tiny-inline-diagnostic.nvim, nvim-origami
- Copilot: copilot.lua + sidekick.lua (CLI wrapper)

## Critical Implementation Rules

### Language & Plugin-Architecture Rules

- Format with stylua before committing: 160 col width, 2-space indent, single-quote preference, `call_parentheses = "None"`, `collapse_simple_statement = "Always"` — write code that already matches this style (e.g. omit parens on single-arg calls where stylua would collapse them)
- One plugin per file in `lua/custom/plugins/<name>.lua`, each returning a lazy.nvim spec table — no registration step needed, lazy.nvim auto-imports via `{ import = "custom.plugins" }` in `init.lua`
- Guard any new UI-only plugin spec with `cond = not vim.g.vscode` so it's skipped under VSCode/Windsurf
- `lua/kickstart/plugins/` holds optional upstream kickstart extras (gitsigns, neo-tree, debug, lint, autopairs, indent_line) — most are disabled by default; don't assume they're active without checking `init.lua`
- LSP keymaps are centralized in the `LspAttach` autocommand in `init.lua` (~line 550) — add new LSP keymaps there, not scattered elsewhere
- Since this config is based on kickstart.nvim, prefer patterns consistent with upstream conventions unless there's a clear reason to diverge (note the divergence in a comment if so)

### Development Workflow Rules

- No CI/build step — validate changes by starting Neovim and running `:checkhealth`, `:Lazy sync`, and exercising the changed keymap/plugin manually
- `:Lazy sync` installs/updates/removes plugins; `:Mason` manages LSP servers/formatters — don't hand-edit `lazy-lock.json`, let lazy.nvim manage it
- `yaml-schema-router` is a compiled binary; run `update-yaml-schema-router.sh` to rebuild/update it rather than editing the binary or its routing logic ad hoc

### Critical Don't-Miss Rules

- Don't add plugin specs directly to `init.lua`'s inline spec list for new custom plugins — put them in `lua/custom/plugins/` instead; inline specs in `init.lua` are reserved for the original kickstart-provided plugins
- Don't assume format-on-save; a change won't be auto-styled — run stylua before considering a Lua edit done
- `iron.lua.bak` in `lua/custom/plugins/` is intentionally disabled (`.bak` suffix) — don't rename/re-enable without being asked
- Scooter integration (`<leader>sR`) callback `_G.EditLineFromScooter()` is wired into `init.lua` (~lines 246–300) — treat as fragile glue code; changes there risk breaking the search/replace jump-back flow

---

## Usage Guidelines

**For AI Agents:**

- Read this file before implementing any code
- Follow ALL rules exactly as documented
- When in doubt, prefer the more restrictive option
- Update this file if new patterns emerge

**For Humans:**

- Keep this file lean and focused on agent needs
- Update when technology stack changes
- Review quarterly for outdated rules
- Remove rules that become obvious over time

Last Updated: 2026-08-07
