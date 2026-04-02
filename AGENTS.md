# AGENTS.md
## Scope
This is a personal dotfiles repo, not a conventional application.
Most first-party code lives in:
- `.config/nvim/` for Neovim Lua config
- `.zshrc` for shell setup
- `.tmux.conf` for tmux setup
- `.wezterm.lua` for WezTerm setup
The `.tmux/plugins/` tree is vendored or upstream-managed plugin code.
Do not treat `.tmux/plugins/**` as first-party unless the task explicitly targets it.

## Additional Agent Rules
Checked for extra repository instructions and found none:
- No pre-existing root `AGENTS.md`
- No `.cursorrules`
- No `.cursor/rules/`
- No `.github/copilot-instructions.md`
If those files appear later, treat them as additional instructions.

## Repository Shape
This repo has no root `package.json`, `pyproject.toml`, `Cargo.toml`, or `go.mod`.
There is no root build system, no root unit-test runner, and no single global lint command.
Validation is config-specific:
- Neovim: startup smoke test and Lua formatting
- Zsh: syntax check
- tmux: config parse/startup check
- WezTerm: mostly manual verification

## Ownership Boundaries
Prefer editing only these first-party paths unless asked otherwise:
- `.config/nvim/**`
- `.zshrc`
- `.tmux.conf`
- `.wezterm.lua`
Avoid casual edits under `.tmux/plugins/**`.
If you must edit vendored code, keep changes minimal and state clearly that you are modifying upstream-managed files.

## Build / Lint / Test Commands
Run commands from `/Users/flaco/dotfiles` unless noted otherwise.

### Neovim
Primary smoke test after Neovim changes:
```bash
nvim --headless '+quitall'
```
This succeeded in the current environment.
Lua formatting is defined by `.config/nvim/.stylelua.toml`:
```bash
stylua .config/nvim
stylua --check .config/nvim
```
`stylua` is referenced by the config but was not installed in the current environment.
Treat it as an expected external dependency rather than a guaranteed global binary.

### Zsh
Syntax check after editing `.zshrc`:
```bash
zsh -n .zshrc
```
This succeeded in the current environment.

### tmux
Parse/startup check after editing `.tmux.conf`:
```bash
tmux -f "/Users/flaco/dotfiles/.tmux.conf" start-server
```
This succeeded in the current environment.

### WezTerm
There is no lightweight repo-local automated verifier for `.wezterm.lua`.
Preferred validation is manual: launch WezTerm and confirm the config loads.

### External Tools Referenced By Neovim
The Neovim config installs or expects these through Mason:
- `prettier`
- `stylua`
- `isort`
- `black`
- `eslint_d`
- `djlint`
- `sqlfluff`
Do not assume they are globally installed.
Check availability before building automation around them.

## Single-Test Guidance
There is no first-party single-test runner because this repo is a set of configs, not an app with a test suite.
Use the narrowest relevant smoke test instead:
- Neovim-only change: `nvim --headless '+quitall'`
- Lua formatting check: `stylua --check .config/nvim`
- Single Lua file formatting check: `stylua --check .config/nvim/lua/flaco/path/to/file.lua`
- Zsh-only change: `zsh -n .zshrc`
- tmux-only change: `tmux -f "/Users/flaco/dotfiles/.tmux.conf" start-server`

## Vendored tmux Plugin Tests
Only use these if you intentionally edit `.tmux/plugins/**`.
Some vendored plugins include a shell test harness under `tests/harness.sh`.
From the plugin directory, a single test looks like:
```bash
bash tests/harness.sh -t tests/pane_styling.sh -e tests/pane_styling_expected.txt
```
Examples currently using this pattern:
- `.tmux/plugins/catppuccin`
- `.tmux/plugins/tmux`
This is upstream plugin testing, not the normal validation path for repo-owned dotfiles.

## Code Style Guidelines
### General Principles
- Make the smallest correct change.
- Preserve the existing structure of each config file.
- Keep related settings grouped together.
- Favor readability over cleverness.
- Avoid new helper modules unless the repetition is substantial.
- Do not add package-management or CI scaffolding unless explicitly requested.

### Lua Style
Most Neovim files are simple Lua modules that return plugin spec tables.
- Use 2-space indentation for Lua; `.config/nvim/.stylelua.toml` is the formatter source of truth.
- Prefer `return { ... }` plugin specs.
- Prefer double quotes.
- Use trailing commas in multiline tables.
- Keep comments short and practical.
- Keep `require(...)` calls near the top of the module or near the top of `config = function()`.
- Use one local per imported module, for example `local telescope = require("telescope")`.
- Keep table keys unquoted when Lua allows it.
There is some formatting inconsistency across existing Lua files.
When touching a file, prefer formatter-compatible output, but do not reformat unrelated files just for cleanup.

### Imports And Dependencies
- Import only what the file uses.
- Prefer direct `require` calls over indirection.
- Use `pcall(require, ...)` only for genuinely optional integrations.
- `dadbod.lua` is a good example: it guards optional `cmp` integration with `pcall`.

### Naming
- Use descriptive locals such as `lint_augroup`, `capabilities`, `builtin`, and `keymap`.
- Keep filenames lowercase and consistent with the current repo, for example `todo-comments.lua` and `indent-blankline.lua`.
- Match the existing module layout under `flaco.core` and `flaco.plugins`.

### Types
This repo does not use a static type system in first-party code.
- Do not introduce annotation frameworks or type layers.
- Express intent through clear naming and small tables.

### Error Handling
- Prefer early returns over nested conditionals.
- Use guarded `pcall` only when a dependency is truly optional.
- Do not silently swallow real startup/configuration failures in core paths.
- Keep fallbacks explicit, like the `sqlls` root fallback in `mason.lua`.

### Neovim Config Patterns
- Keep plugin declarations declarative.
- Put keymaps close to the feature they configure.
- Use `vim.api.nvim_create_autocmd` and `vim.api.nvim_create_augroup` for event-driven behavior.
- Add `desc` to user-facing keymaps when practical.
- Use small local aliases like `local keymap = vim.keymap` only when they reduce repetition.

### Shell And tmux Style
For `.zshrc` and `.tmux.conf`:
- Add settings in the relevant section instead of appending them randomly.
- Quote paths and expansions when needed.
- Preserve the current declarative layout of aliases, exports, binds, and options.
- Do not replace straightforward config with generated or overly abstract code.

### WezTerm Style
- Continue using `local wezterm = require("wezterm")`.
- Continue using `local config = wezterm.config_builder()`.
- Mutate `config` with direct assignments, then `return config`.
- Keep commented alternate settings only when they are genuinely useful and already fit the file’s style.

## Validation Matrix
After Neovim or Lua edits:
```bash
nvim --headless '+quitall'
stylua --check .config/nvim
```
After `.zshrc` edits:
```bash
zsh -n .zshrc
```
After `.tmux.conf` edits:
```bash
tmux -f "/Users/flaco/dotfiles/.tmux.conf" start-server
```
After `.wezterm.lua` edits:
- Launch WezTerm manually and confirm the config loads as expected.
