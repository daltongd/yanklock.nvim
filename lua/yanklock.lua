local M = {}

LOCKED = true
UNLOCKED = false
EMPTY = {}

M._state = {}
M._reset_state = function()
	M._state = { lock = UNLOCKED, cache = {} }
end
M._reset_state()

local apply_defaults = function(options)
	return {
		modes = options.modes or { "n", "x" },
	}
end

M.setup = function(options)
	M.options = apply_defaults(options or {})

	M._reset_state()
end

local get_keymap = function(mode, mapping)
	local keymaps = vim.api.nvim_get_keymap(mode)
	for _, keymap in ipairs(keymaps) do
		if keymap.lhs == mapping then
			return keymap
		end
	end
end

local replace = function(mode, mapping, replacement)
	M._state.cache[mode] = M._state.cache[mode] or {}
	M._state.cache[mode][mapping] = get_keymap(mode, mapping) or EMPTY
	vim.keymap.set(mode, mapping, replacement)
end

local revert = function()
	for mode, mappings in pairs(M._state.cache) do
		for mapping, rhs in pairs(mappings) do
			if M._state.cache[mode][mapping] ~= EMPTY then
				vim.keymap.set(mode, mapping, rhs.rhs)
			else
				vim.keymap.del(mode, mapping)
			end
		end
	end
end

M.lock = function()
	if M._state.lock == LOCKED then
		print("yanklock: already locked")
		return
	end
	M._state.lock = LOCKED

	for _, mode in ipairs(M.options.modes) do
		replace(mode, "p", '"0p')
		replace(mode, "P", '"0P')
	end

	print("yanklock: locked")
end

M.unlock = function()
	if M._state.lock == UNLOCKED then
		print("yanklock: already unlocked")
		return
	end
	M._state.lock = UNLOCKED

	revert()

	print("yanklock: unlocked")
end

M.toggle = function()
	if M._state.lock then
		M.unlock()
	else
		M.lock()
	end
end

-- vim.keymap.set("n", "<leader>ly", ":lua require('yanklock').toggle()<CR>")

return M
