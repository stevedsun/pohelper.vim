local M = {}

-- This function calls a prompt from ollama.nvim.
-- It assumes the prompt is configured with `action = "replace"`
-- to automatically replace the visual selection.
function M.run_prompt_on_selection(prompt_name)
	-- The ollama.nvim plugin will handle getting the visual selection
	-- and replacing it with the output when `action = "replace"` is used.
	require("ollama").prompt(prompt_name)
end

return M
