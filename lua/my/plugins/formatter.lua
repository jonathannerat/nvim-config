local M = {}

local clike_format = function()
	return {
		exe = "clang-format",
		args = { "--assume-filename", vim.api.nvim_buf_get_name(0) },
		stdin = true,
		cwd = vim.fn.expand "%:p:h",
	}
end

local shell_format = function()
	return {
		exe = "shfmt",
		args = { "-i", 2 },
		stdin = true,
	}
end

M.config = {
	filetype = {
		c = { clike_format },
		cpp = { clike_format },
		lua = {
			function()
				return {
					exe = "stylua",
					args = {
						"--config-path " .. os.getenv "XDG_CONFIG_HOME" .. "/stylua/stylua.toml",
						"-",
					},
					stdin = true,
				}
			end,
		},
		python = {
			function()
				return {
					exe = "black",
					args = { "-" },
					stdin = true,
				}
			end,
		},
		rust = {
			function()
				return {
					exe = "rustfmt",
					args = { "--emit=stdout" },
					stdin = true,
				}
			end,
		},
		sh = { shell_format },
		zsh = { shell_format },
	},
}

M.setup = function()
	require("formatter").setup(M.config)
end

return M
