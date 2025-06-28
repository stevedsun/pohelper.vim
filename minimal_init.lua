-- Set up package path
local path = vim.fn.stdpath("data") .. "/site"
vim.opt.packpath:prepend(path)

-- Add the plugin itself to the runtime path
vim.opt.runtimepath:prepend(vim.fn.getcwd())

-- Install lazy.nvim package manager
local lazypath = path .. "/pack/lazy/start/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Configure plugins
require("lazy").setup({
	-- Add dependencies
	"nvim-lua/plenary.nvim",
	"nvim-lua/nui.nvim",
	"nomnivore/ollama.nvim",

	-- Your plugin
	{
		dir = vim.fn.getcwd(),
		-- lazy.nvim will also call the setup function for you
	},
})

-- Example ollama.nvim setup (as in your README)
require("ollama").setup({
	prompts = {
		PBI_Refine = {
			prompt = [=[
Translate and refine the following PBI into proper English in "As … I want … So that …" format:
$input
      ]=],
			model = "qwen2.5:3b",
			action = "replace",
		},
		Translate_En = {
			prompt = "Translate the following to fluent English:\n$input",
			model = "qwen2.5:3b",
			action = "replace",
		},
	},
})
