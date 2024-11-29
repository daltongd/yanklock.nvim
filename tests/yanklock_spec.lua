local get_keymap = function(mode, mapping)
	local keymaps = vim.api.nvim_get_keymap(mode)
	for _, keymap in ipairs(keymaps) do
		if keymap.lhs == mapping then
			return keymap
		end
	end
end

local assert_keymap_eq = function(mode, mapping, expected)
	local keymap = get_keymap(mode, mapping)
	if expected then
		assert.are_not.equal(nil, keymap)
		assert.are.equal(keymap.rhs, expected)
	else
		assert.are.equal(nil, keymap)
	end
end

describe("yanklock setup", function()
	it("module exists", function()
		require("yanklock")
	end)

	it("defaults are set", function()
		local yanklock = require("yanklock")
		yanklock.setup()
		assert.are.equal(table.concat(yanklock.options), table.concat({ modes = { "n", "x" } }))
	end)
end)

local yanklock = require("yanklock")

describe("yanklock", function()
	before_each(function()
		yanklock.setup()
		pcall(vim.keymap.del, "n", "p")
		pcall(vim.keymap.del, "n", "P")
		pcall(vim.keymap.del, "x", "p")
		pcall(vim.keymap.del, "x", "P")
	end)

	it("can lock", function()
		yanklock.lock()
		assert_keymap_eq("n", "p", '"0p')
		assert_keymap_eq("n", "P", '"0P')
		assert_keymap_eq("x", "p", '"0p')
		assert_keymap_eq("x", "P", '"0P')
	end)

	it("can unlock", function()
		yanklock.lock()
		assert_keymap_eq("n", "p", '"0p')
		assert_keymap_eq("n", "P", '"0P')
		assert_keymap_eq("x", "p", '"0p')
		assert_keymap_eq("x", "P", '"0P')
		yanklock.unlock()
		assert_keymap_eq("n", "p", nil)
		assert_keymap_eq("n", "P", nil)
		assert_keymap_eq("x", "p", nil)
		assert_keymap_eq("x", "P", nil)
	end)

	it("can revert to previous keymap", function()
		vim.keymap.set("n", "P", ":lua test<CR>") -- rather uncommon usecase
		vim.keymap.set("x", "p", "P") -- potentially common usecase
		yanklock.lock()
		assert_keymap_eq("n", "p", '"0p')
		assert_keymap_eq("n", "P", '"0P')
		assert_keymap_eq("x", "p", '"0p')
		assert_keymap_eq("x", "P", '"0P')
		yanklock.unlock()
		assert_keymap_eq("n", "p", nil)
		assert_keymap_eq("n", "P", ":lua test<CR>")
		assert_keymap_eq("x", "p", "P")
		assert_keymap_eq("x", "P", nil)
	end)

	it("can toggle", function()
		yanklock.lock()
		assert_keymap_eq("n", "p", '"0p')
		assert_keymap_eq("n", "P", '"0P')
		assert_keymap_eq("x", "p", '"0p')
		assert_keymap_eq("x", "P", '"0P')
		yanklock.unlock()
		assert_keymap_eq("n", "p", nil)
		assert_keymap_eq("n", "P", nil)
		assert_keymap_eq("x", "p", nil)
		assert_keymap_eq("x", "P", nil)
	end)
end)

describe("yanklock limit modes", function()
	before_each(function()
		pcall(vim.keymap.del, "n", "p")
		pcall(vim.keymap.del, "n", "P")
		pcall(vim.keymap.del, "x", "p")
		pcall(vim.keymap.del, "x", "P")
	end)

	it("can lock only in normal mode", function()
		yanklock.setup({ modes = { "n" } })
		yanklock.lock()
		assert_keymap_eq("n", "p", '"0p')
		assert_keymap_eq("n", "P", '"0P')
		assert_keymap_eq("x", "p", nil)
		assert_keymap_eq("x", "P", nil)
	end)

	it("can lock only in visual mode", function()
		yanklock.setup({ modes = { "x" } })
		yanklock.lock()
		assert_keymap_eq("n", "p", nil)
		assert_keymap_eq("n", "P", nil)
		assert_keymap_eq("x", "p", '"0p')
		assert_keymap_eq("x", "P", '"0P')
	end)
end)
