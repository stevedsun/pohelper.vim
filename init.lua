-- Example configuration for your nvim-scrum-plugin.
-- Place this in your Neovim configuration where you manage your plugins.
-- For example, if you use lazy.nvim, you would put this in the `opts` function.

require("ollama").setup({
	-- Other ollama.nvim config...
	prompts = {
		PBI_Refine = {
			prompt = [=[
Translate and refine the following PBI into proper English in "As … I want … So that …" format:
$input
      ]=],
			model = "qwen2.5:3b",
			action = "replace",
			-- The `extract` pattern is optional but useful if the model wraps
			-- its output in code blocks.
			extract = "```(.*)```",
		},
		Translate_En = {
			prompt = [=[
Translate the following to fluent English:
$input
      ]=],
			model = "qwen2.5:3b",
			action = "replace",
		},
	},
})
