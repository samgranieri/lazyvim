-- local M = {}
--
-- function M.convert()
-- -- 	local buf = vim.api.nvim_get_current_buf()
-- --
-- -- 	-- Get the current buffer content
-- -- 	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
-- --
-- -- 	-- Perform the replacements
-- -- 	for i, line in ipairs(lines) do
-- -- 		lines[i] = string.gsub(line, "=>", ":")
-- -- 		lines[i] = string.gsub(lines[i], "%bnil%b", "null")
-- -- 		print(i, line)
-- -- 		-- lines[i] = line:gsub("=>", ":"):gsub("%bnil%b", "null")
-- -- 	end
-- --
-- -- 	-- -- Join the lines into a single string
-- -- 	-- local content = table.concat(lines, "\n")
-- -- 	--
-- -- 	-- -- Use jq to format the JSON
-- -- 	-- local handle = io.popen("echo '" .. content .. "' | jq .")
-- -- 	-- local result = handle:read("*a")
-- -- 	-- handle:close()
-- -- 	--
-- -- 	-- -- Split the result back into lines
-- -- 	-- local formatted_lines = {}
-- -- 	-- for line in result:gmatch("[^\r\n]+") do
-- -- 	-- 	table.insert(formatted_lines, line)
-- -- 	-- end
-- -- 	--
-- -- 	-- -- Set the formatted content back to the buffer
-- -- 	-- vim.api.nvim_buf_set_lines(buf, 0, -1, false, formatted_lines)
-- -- end
--
-- return M