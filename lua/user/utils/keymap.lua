local vim_keymap_set = vim.keymap.set

---@alias VimMode "n"|"i"|"v"|"c"|"t"

---@class Keymap
---@field [1] string
---@field [2]? string
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
local function mode(group, keymap)
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

local function rhs(keymap)
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
local function opts(keymap, group)
   local o = {}

   for _, flag in ipairs { "silent", "remap", "buffer", "nowait" } do
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
local function set(keymaps, parent_group)
   parent_group = parent_group or { mode = "normal" }
   local group = vim.tbl_extend("force", parent_group, keymaps.group or {})

   for _, keymap in ipairs(keymaps) do
      if keymap.group then
         ---@cast keymap KeymapGroup
         set(keymap, group)
      else
         ---@cast keymap Keymap
         vim_keymap_set(mode(group, keymap), keymap[1], rhs(keymap), opts(keymap, group))
      end
   end
end

return set
