local M = {}

M.index = function()
	vim.lsp.buf.execute_command({
		command = "zk.index",
		arguments = {vim.api.nvim_buf_get_name(0)},
	})
end

M.new = function(...)
	vim.lsp.buf_request(0, 'workspace/executeCommand', {
		command = "zk.new",
		arguments = {
			vim.api.nvim_buf_get_name(0),
			...
		},
	}, function(_, _, result)
		if (result and result.path) then
			vim.cmd("edit " .. result.path)
		end
	end)
end

return M
