---@class Mapper
local Mapper = {
   _mode = "n",
   _bufnr = nil,
   _options = {},
}

--- Creates a new mapper instance
---@param o table? default instance properties
---@return Mapper a mapper
function Mapper:new(o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   return o
end

--- Bind `mappings` in `mode` mode
---@param mode "normal"|"insert"|"command"|"terminal"|"visual"|"select"
---@param mappings string|table|fun(m:Mapper): nil
---@param rhs string?
---@return Mapper?
function Mapper:mode(mode, mappings, rhs)
   local backup = self._mode
   self._mode = mode:sub(1, 1)

   if mappings then
      self:bind(mappings, rhs)
      self._mode = backup
   else
      return self
   end
end

--- Bind `mappings` in buffer `bufnr`
---@param bufnr number
---@param mappings string|table|fun(m:Mapper): nil
---@param rhs string?
---@return Mapper?
function Mapper:buffer(bufnr, mappings, rhs)
   local backup = self._bufnr
   self._bufnr = bufnr

   if mappings then
      self:bind(mappings, rhs)
      self._bufnr = backup
   else
      return self
   end
end

--- Bind `mappings` with options
---@param options table
---@param mappings string|table|fun(m:Mapper): nil
---@param rhs string?
---@return Mapper?
function Mapper:with_options(options, mappings, rhs)
   local backup = self._options

   self._options = options

   if mappings then
      self:bind(mappings, rhs)
      self._options = backup
   else
      return self
   end
end

--- Bind `mappings` with `opt` option set to true
---@param mapper Mapper
---@param opt "silent"|"noremap"|"expr"|"nowait"
---@param mappings string|table|fun(m:Mapper): nil
---@param rhs string?
---@return Mapper?
local function with_bool_option(mapper, opt, mappings, rhs)
   local options = mapper._options
   local backup = options[opt]

   options[opt] = true
   if mappings then
      Mapper.bind(mapper, mappings, rhs)
      options[opt] = backup
   else
      return mapper
   end
end

--- Bind `mappings` with silent enabled
---@param mappings string|table|fun(m:Mapper): nil
---@param rhs string?
---@return Mapper?
function Mapper:with_silent(mappings, rhs)
   return with_bool_option(self, "silent", mappings, rhs)
end

--- Bind `mappings` with noremap enabled
---@param mappings string|table|fun(m:Mapper): nil
---@param rhs string?
---@return Mapper?
function Mapper:with_noremap(mappings, rhs)
   return with_bool_option(self, "noremap", mappings, rhs)
end

--- Bind `mappings` with expr enabled
---@param mappings string|table|fun(m:Mapper): nil
---@param rhs string?
---@return Mapper?
function Mapper:with_expr(mappings, rhs)
   return with_bool_option(self, "expr", mappings, rhs)
end

--- Bind `mappings` with nowait enabled
---@param mappings string|table|fun(m:Mapper): nil
---@param rhs string?
---@return Mapper?
function Mapper:with_nowait(mappings, rhs)
   return with_bool_option(self, "nowait", mappings, rhs)
end

--- Either binds the table, or calls mappings with the Mapper as an argument
---@param mappings string|table|fun(m:Mapper): nil
---@param rhs string?
function Mapper:bind(mappings, rhs)
   local binder = vim.api.nvim_set_keymap

   if self._bufnr then
      binder = function(...)
         return vim.api.nvim_buf_set_keymap(self._bufnr, ...)
      end
   end

   if type(mappings) == "string" and rhs then
      binder(self._mode, mappings, rhs, self._options, self._bufnr)
   elseif type(mappings) == "table" then
      for lhs, _rhs in pairs(mappings) do
         binder(self._mode, lhs, _rhs, self._options)
      end
   elseif type(mappings) == "function" then
      mappings(self)
   end
end

return Mapper
