# Manual Testing Guide

This guide provides the steps to manually test the `nvim-scrum-plugin` in a controlled environment.

## 1. Minimal Configuration

To test the plugin in isolation, use the provided `minimal_init.lua` configuration file. This file loads only the necessary dependencies for the plugin to run.

### `minimal_init.lua`

```lua
-- Set up package path
local path = vim.fn.stdpath('data') .. '/site'
vim.opt.packpath:prepend(path)

-- Add the plugin itself to the runtime path
vim.opt.runtimepath:prepend(vim.fn.getcwd())

-- Install lazy.nvim package manager
local lazypath = path .. '/pack/lazy/start/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Configure plugins
require('lazy').setup({
  -- Add dependencies
  'nvim-lua/plenary.nvim',
  'nvim-lua/nui.nvim',
  'nomnivore/ollama.nvim',

  -- Your plugin
  {
    dir = vim.fn.getcwd(),
  },
})

-- Example ollama.nvim setup (as in your README)
require('ollama').setup({
  prompts = {
    PBI_Refine = {
      prompt = [=[
Translate and refine the following PBI into proper English in "As … I want … So that …" format:
$input
      ]=],
      model = "mistral",
      action = "replace",
    },
    Translate_En = {
      prompt = [=[
Translate the following to fluent English:
$input
      ]=],
      model = "mistral",
      action = "replace",
    },
  }
})
```

## 2. Start Neovim

Launch Neovim from the root of the project directory with the following command:

```bash
nvim -u minimal_init.lua
```

This will start Neovim with only your plugin and its dependencies loaded.

## 3. How to Test

Once Neovim is running, you can test the plugin's features:

### `:NewPBI`

- Run the command `:NewPBI`.
- A series of popups will appear, asking for the Title, Role, Feature, and Benefit.
- After filling in the information, a new buffer will open with the PBI template populated with your input.

### `:NewMeeting`

- Run the command `:NewMeeting`.
- Popups will ask for the Topic and Attendees.
- A new buffer will open with the meeting notes template populated with your input.

### `:PBIRefine` and `:TranslateEn`

- These commands require text to be visually selected.
- Write some text, then enter visual mode (`v`) and select it.
- Run `:PBIRefine` or `:TranslateEn`.
- The selected text will be replaced with the output from the Ollama model.

### `:ActionSync`

- Open a file with action items in the format `- [ ] Action: ...`.
- Run the command `:ActionSync`.
- The action items will be appended to a `backlog.md` file in the project's root directory.

## 4. Debugging

If you encounter issues, you can add `print()` statements to the Lua code to inspect variables. Use `vim.inspect()` to print tables.

For example, to debug the `action_sync` function, you could modify `lua/pohelper/init.lua`:

```lua
function M.action_sync()
  -- ...
  local actions = {}

  for _, line in ipairs(lines) do
    if string.match(line, "%s*%- %[ %] Action: .*") then
      table.insert(actions, line)
    end
  end

  -- Add this line to inspect the actions table
  print(vim.inspect(actions))

  -- ...
end
```

After running the command, you can view the output with `:messages` in Neovim.
