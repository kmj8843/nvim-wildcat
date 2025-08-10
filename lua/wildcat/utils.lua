local M = {}

local progress_timer = nil

function M.show_progress(message)
	local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
	local i = 1

	progress_timer = vim.loop.new_timer()
	progress_timer:start(
		0,
		100,
		vim.schedule_wrap(function()
			if i > #frames then
				i = 1
			end
			vim.api.nvim_echo({ { frames[i] .. " " .. message, "Comment" } }, false, {})
			i = i + 1
		end)
	)
end

function M.stop_progress()
	if progress_timer then
		progress_timer:stop()
		progress_timer:close()
		progress_timer = nil
		vim.api.nvim_echo({ { "", "None" } }, false, {})
	end
end

return M
