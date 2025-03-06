local M = {}

--- Bootstrap a plugin into rtp
---@param opts {url: string, name: string, branch: string, package: string}
function M.bootstrap(opts)
	local url = opts.url
	local branch = opts.branch or "main"
	local name = opts.name or url:match("%w+://.+/.+/(.+)")
	local packname = opts.package or name
	name = name:sub(-4) == ".git" and name:sub(1, -5) or name
	local pluginpath = vim.fn.stdpath("data") .. "/site/pack/" .. packname .. "/start/" .. name

	if not vim.uv.fs_stat(pluginpath) then
		local out = vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			url,
			"--branch=" .. branch,
			pluginpath,
		})

		if vim.v.shell_error ~= 0 then
			vim.api.nvim_echo({
				{ "Failed to clone " .. name .. ":\n", "ErrorMsg" },
				{ out, "WarningMsg" },
				{ "\nPress any key to exit..." },
			}, true, {})
			vim.fn.getchar()
			os.exit(1)
		end
	end

	vim.opt.rtp:prepend(pluginpath)
end

--- Set VIM options using a table
---@param options table key-value pairs are interpreted as (option = value), while values of
---       the table are treated as boolean values. In key-value format, if value is a table,
---       the function checks if the table contains a key with an "action" (append, prepend
---       or remove), and performs that actions insted of asignment
function M.set(options)
	local opt_table_actions = { "append", "prepend", "remove" }

	for k, v in pairs(options) do
		local option, value, action
		if type(k) == "number" then
			option = v
			value = true

			if option:sub(1, 2) == "no" then
				option = option:sub(3)
				value = false
			end
		elseif type(k) == "string" then
			option = k
			value = v
		end

		if type(value) == "table" then
			for _, a in ipairs(opt_table_actions) do
				if value[a] ~= nil then
					action = a
					value = value[a]
				end
			end

			if action == nil then
				vim.opt[option] = value
			else
				local opt = vim.opt[option]

				opt[action](opt, value)
			end
		else
			vim.opt[option] = value
		end
	end
end

---@alias VimMode "n"|"i"|"v"|"c"|"t"|"x"

---@class Keymap
---@field [1] string
---@field [2]? string|function
---@field vim? string
---@field lua? string
---@field desc? string
---@field mode? string|string[]
---@field disable? boolean
---@field silent? boolean
---@field remap? boolean
---@field buffer? boolean|integer
---@field nowait? boolean

---@class GroupOptions
---@field name? string
---@field mode? string|string[]
---@field silent? boolean
---@field remap? boolean
---@field buffer? boolean|integer
---@field nowait? boolean

---@class KeymapGroup
---@field group? GroupOptions
---@field [number] Keymap|KeymapGroup

--- Get mode from group
---@param group GroupOptions
---@param keymap Keymap
---@return VimMode|VimMode[]
local function map_mode(group, keymap)
	local m = keymap.mode or group.mode or "normal"

	if type(m) == "table" then
		return vim.tbl_map(function(v)
			return v:sub(1, 1)
		end, m)
	else
		return m:sub(1, 1)
	end
end

local VIM_PREFIX = ":"
local LUA_PREFIX = VIM_PREFIX .. "lua "
local CR = "<CR>"

local function map_rhs(keymap)
	local ret

	if keymap[2] then
		ret = keymap[2]
	elseif keymap.disable then
		ret = ""
	elseif keymap.vim then
		ret = VIM_PREFIX .. keymap.vim .. CR
	elseif keymap.lua then
		ret = LUA_PREFIX .. keymap.lua .. CR
	end

	return ret
end

--- Get mapping options from keymap and group
---@param keymap Keymap
---@param group GroupOptions
local function map_opts(keymap, group)
	local o = {}

	for _, flag in ipairs({ "silent", "remap", "buffer", "nowait" }) do
		o[flag] = keymap[flag] == nil and group[flag] or keymap[flag]
	end

	local desc = keymap.desc

	if group.name and desc then
		desc = "[" .. group.name .. "] " .. desc
	end

	o.desc = desc

	return o
end

--- Set multiple keymaps at once
---@param keymaps KeymapGroup
---@param parent_group? GroupOptions
function M.map(keymaps, parent_group)
	parent_group = parent_group or { mode = "normal" }
	local group = vim.tbl_extend("force", parent_group, keymaps.group or {})

	for _, keymap in ipairs(keymaps) do
		if keymap.group then
			---@cast keymap KeymapGroup
			M.map(keymap, group)
		else
			---@cast keymap Keymap
			vim.keymap.set(map_mode(group, keymap), keymap[1], map_rhs(keymap), map_opts(keymap, group))
		end
	end
end

local default_config = require("my.config")
local has_overrides, override_config = pcall(require, "my.config.overrides")

function M.config(key, default)
	local keys = vim.split(key, ".", { plain = true })
	local value = vim.tbl_get(default_config, unpack(keys))
	local option = value ~= nil and value or default

	if has_overrides then
		value = vim.tbl_get(override_config, unpack(keys))
		option = value ~= nil and value or option
	end

	return option
end

---Setup intended for plugins
---@param module string|table Name of the module to setup, or a table mapping modules to their opts
---@param opts? table|true Options of the module
function M.setup(module, opts)
	if type(module) == "string" then
		local has_mod, mod = pcall(require, module)

		if not has_mod then
			vim.notify(("Module '%s' is not avaible"):format(module), vim.log.levels.ERROR)
			return
		end

		if mod and type(mod) == "table" and mod.setup and opts then
			if opts == true then
				mod.setup()
			else
				mod.setup(opts)
			end
		end
	else
		for key, value in pairs(module) do
			local m, o

			if type(key) == "string" then
				m, o = key, value
			elseif type(value) == "string" then
				m, o = value, true
			end

			M.setup(m, o)
		end
	end
end

return M
