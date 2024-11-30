-- based on https://github.com/lima1909/resty.nvim/blob/main/spec/minimal_init.lua

local plenary_root = "/tmp/plenary.nvim"
if vim.fn.isdirectory(plenary_root) == 0 then
	vim.fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/nvim-lua/plenary.nvim",
		plenary_root,
	})
end

vim.opt.rtp:append(".")
vim.opt.rtp:append(plenary_root)
vim.cmd.runtime({ "plugin/plenary.vim", bang = true })

require("plenary.busted")
