local M = {}
local templates = require("pohelper.templates")

function M.new_pbi()
	local Input = require("nui.input")
	local event = require("nui.utils.autocmd").event

	local inputs = {
		{ label = "Enter Title", value = "" },
		{ label = "Enter Role", value = "" },
		{ label = "Enter Feature", value = "" },
		{ label = "Enter Benefit", value = "" },
	}

	local current_input = 1

	local function show_input()
		if current_input > #inputs then
			local pbi_template = templates.get("pbi")
			local pbi_content = pbi_template
			pbi_content = string.gsub(pbi_content, "{title}", inputs[1].value)
			pbi_content = string.gsub(pbi_content, "{role}", inputs[2].value)
			pbi_content = string.gsub(pbi_content, "{feature}", inputs[3].value)
			pbi_content = string.gsub(pbi_content, "{benefit}", inputs[4].value)

			vim.cmd("enew")
			vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(pbi_content, "\n"))
			return
		end

		local input = Input({
			position = "50%",
			size = {
				width = 40,
			},
			border = {
				style = "single",
				text = {
					top = inputs[current_input].label,
					top_align = "center",
				},
			},
			win_options = {
				winhighlight = "Normal:Normal,FloatBorder:Normal",
			},
		}, {
			on_submit = function(value)
				inputs[current_input].value = value
				current_input = current_input + 1
				vim.schedule(show_input)
			end,
		})

		input:mount()

		input:on(event.BufLeave, function()
			input:unmount()
		end, { once = true })
		end

	show_input()
end

function M.new_meeting()
	local Input = require("nui.input")
	local event = require("nui.utils.autocmd").event

	local inputs = {
		{ label = "Enter Topic", value = "" },
		{ label = "Enter Attendees", value = "" },
	}

	local current_input = 1

	local function show_input()
		if current_input > #inputs then
			local date = os.date("!%Y-%m-%d")

			local meeting_template = templates.get("meeting")
			local meeting_content = meeting_template
			meeting_content = string.gsub(meeting_content, "{topic}", inputs[1].value)
			meeting_content = string.gsub(meeting_content, "{attendees}", inputs[2].value)
			meeting_content = string.gsub(meeting_content, "{date}", date)

			vim.cmd("enew")
			vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(meeting_content, "\n"))
			return
		end

		local input = Input({
			position = "50%",
			size = {
				width = 40,
			},
			border = {
				style = "single",
				text = {
					top = inputs[current_input].label,
					top_align = "center",
				},
			},
			win_options = {
				winhighlight = "Normal:Normal,FloatBorder:Normal",
			},
		}, {
			on_submit = function(value)
				inputs[current_input].value = value
				current_input = current_input + 1
				vim.schedule(show_input)
			end,
		})

		input:mount()

		input:on(event.BufLeave, function()
			input:unmount()
		end, { once = true })
		end

	show_input()
end

function M.action_sync()
	local backlog_file = "backlog.md"

	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local actions = {}

	for _, line in ipairs(lines) do
		if string.match(line, "%s*%- %[ %] Action: .*") then
			table.insert(actions, line)
		end
	end

	if #actions > 0 then
		local f = io.open(backlog_file, "a")
		if f then
			for _, action in ipairs(actions) do
				f:write(action .. "\n")
			end
			f:close()
			print("Synced " .. #actions .. " action(s) to " .. backlog_file)
		else
			print("Error: Could not open " .. backlog_file)
		end
	else
		print("No actions found to sync.")
	end
end

return M