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

describe("yanklock", function()
	before_each(function()
		require("yanklock")._reset_state()
		pcall(vim.keymap.del, "n", "p")
		pcall(vim.keymap.del, "n", "P")
		pcall(vim.keymap.del, "x", "p")
		pcall(vim.keymap.del, "x", "P")
	end)

	it("module exists", function()
		require("yanklock")
	end)

	it("can lock", function()
		require("yanklock").lock()
		assert_keymap_eq("n", "p", '"0p')
		assert_keymap_eq("n", "P", '"0P')
		assert_keymap_eq("x", "p", '"0p')
		assert_keymap_eq("x", "P", '"0P')
	end)

	it("can unlock", function()
		require("yanklock").lock()
		assert_keymap_eq("n", "p", '"0p')
		assert_keymap_eq("n", "P", '"0P')
		assert_keymap_eq("x", "p", '"0p')
		assert_keymap_eq("x", "P", '"0P')
		require("yanklock").unlock()
		assert_keymap_eq("n", "p", nil)
		assert_keymap_eq("n", "P", nil)
		assert_keymap_eq("x", "p", nil)
		assert_keymap_eq("x", "P", nil)
	end)

	it("can revert to previous keymap", function()
		vim.keymap.set("n", "P", ":lua test<CR>") -- rather uncommon usecase
		vim.keymap.set("x", "p", "P") -- potentially common usecase
		require("yanklock").lock()
		assert_keymap_eq("n", "p", '"0p')
		assert_keymap_eq("n", "P", '"0P')
		assert_keymap_eq("x", "p", '"0p')
		assert_keymap_eq("x", "P", '"0P')
		require("yanklock").unlock()
		assert_keymap_eq("n", "p", nil)
		assert_keymap_eq("n", "P", ":lua test<CR>")
		assert_keymap_eq("x", "p", "P")
		assert_keymap_eq("x", "P", nil)
	end)

	it("can toggle", function()
		require("yanklock").toggle()
		assert_keymap_eq("n", "p", '"0p')
		assert_keymap_eq("n", "P", '"0P')
		assert_keymap_eq("x", "p", '"0p')
		assert_keymap_eq("x", "P", '"0P')
		require("yanklock").toggle()
		assert_keymap_eq("n", "p", nil)
		assert_keymap_eq("n", "P", nil)
		assert_keymap_eq("x", "p", nil)
		assert_keymap_eq("x", "P", nil)
	end)
end)
