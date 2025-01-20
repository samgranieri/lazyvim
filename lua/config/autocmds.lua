-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- local convert_ruby_to_json = require("plugins.convert_ruby_to_json")

-- Create a command to run the conversion
if vim.fn.getenv("TERM_PROGRAM") == "ghostty" then
	vim.opt.title = true
	vim.opt.titlestring = "%{fnamemodify(getcwd(), ':t')}"
end

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.json.jbuilder",
	command = "set filetype=ruby",
})
