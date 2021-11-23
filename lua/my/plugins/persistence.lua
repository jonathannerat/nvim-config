local M = {}

function M.setup()
	require("persistence").setup {
		dir = vim.fn.expand(vim.fn.stdpath "data" .. "/sessions/"),
	}
end

return M
