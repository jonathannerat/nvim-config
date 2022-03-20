local M = {}

local dap = require "dap"

M.adapters = {
	lldb = {
		type = "executable",
		command = "/usr/bin/lldb-vscode",
		name = "lldb",
	},
}

M.configurations = {
	cpp = {
		{
			name = "Launch file",
			type = "lldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
		},
		{
			name = "Launch file with stdio",
			type = "lldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			args = { "<scenes/scene.txt" },
			stopOnEntry = false,
			linux = {
				MIMode = "lldb",
			},
		},
	},
}

M.configurations.c = M.configurations.cpp

M.setup = function()
	for name, adapter in pairs(M.adapters) do
		dap.adapters[name] = adapter
	end

	for name, config in pairs(M.configurations) do
		dap.configurations[name] = config
	end
end

return M
