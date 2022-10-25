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

local prettier_format = require("formatter.defaults.prettier")

M.config = {
	filetype = {
		blade = { prettier_format },
		c = { clike_format },
		cpp = { clike_format },
		lua = {
			function()
				return {
					exe = "stylua",
					args = {
						"--config-path " .. os.getenv "XDG_CONFIG_HOME" .. "/stylua/stylua.toml",
						"-"
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
		haskell = {
			function ()
				return {
					exe = "ormolu",
					stdin = true,
				}
			end
		},
		javascript = {
			prettier_format,
		},
		vue = {
			prettier_format,
		},
		php = {
			function ()
				return {
					exe = "prettier",
					args = {
						"--config-precedence", "prefer-file", "--stdin-filepath", vim.fn.shellescape(vim.api.nvim_buf_get_name(0)),
					},
					stdin = true,
					try_node_modules = true,
				}
			end
		},
		json = {
		   prettier_format
		}
	},
}

M.setup = function()
	require("formatter").setup(M.config)
end

return M
