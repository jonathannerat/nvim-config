local options = require "user.options"

local CACHE = {}
local LSP_PROGRESS_LOG_LEVEL = vim.log.levels.INFO
local SPINNER_TIMEOUT = options("lsp.progress.spinner_timeout", 100)
local END_TIMEOUT = options("lsp.progress.end_timeout", 3000)
local SPINNER_ICONS = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

local function get_cached(client_id, token)
   if not CACHE[client_id] then
      CACHE[client_id] = {}
   end

   if not CACHE[client_id][token] then
      CACHE[client_id][token] = {}
   end

   return CACHE[client_id][token]
end

local function format_title(title, client_name)
   return client_name .. (#title > 0 and ": " .. title or "")
end

local function format_message(message, percentage)
   return (percentage and percentage .. "%\t" or "") .. (message or "")
end

local function update_spinner(client_id, token)
   local data = get_cached(client_id, token)

   if data.spinner then
      local next_spinner = (data.spinner + 1) % #SPINNER_ICONS
      data.spinner = next_spinner

      data.notification = vim.notify(nil, nil, {
         hide_from_history = true,
         icon = SPINNER_ICONS[next_spinner],
         replace = data.notification,
      })

      vim.defer_fn(function()
         update_spinner(client_id, token)
      end, SPINNER_TIMEOUT)
   end
end

return function(args)
   local client_id = args.data.client_id
   local result = args.data.params
   local val = result.value

   if not val.kind then
      return
   end

   local data = get_cached(client_id, result.token)

   if val.kind == "begin" then
      local message = format_message(val.message, val.percentage)

      data.notification = vim.notify(message, LSP_PROGRESS_LOG_LEVEL, {
         title = format_title(val.title, vim.lsp.get_client_by_id(client_id).name),
         icon = SPINNER_ICONS[1],
         timeout = false,
         hide_from_history = false,
      })

      data.spinner = 1
      update_spinner(client_id, result.token)
   elseif val.kind == "report" then
      data.notification = vim.notify(format_message(val.message, val.percentage), LSP_PROGRESS_LOG_LEVEL, {
         replace = data.notification,
         hide_from_history = false,
      })
   elseif val.kind == "end" then
      data.notification =
         vim.notify(val.message and format_message(val.message) or "Complete", LSP_PROGRESS_LOG_LEVEL, {
            icon = " ",
            replace = data.notification,
            timeout = END_TIMEOUT,
         })

      data.spinner = nil
   end
end
