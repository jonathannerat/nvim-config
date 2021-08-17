local M = {}

function M.config()
	require("persistence").setup {
		dir = vim.fn.expand(vim.fn.stdpath "data" .. "/sessions/"),
	}
end

return M
