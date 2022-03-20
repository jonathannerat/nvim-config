local function get_clipboard()
	return sn(nil, { i(1, vim.fn.getreg("+", 1)) })
end

return {
	s("href", {
		t "[",
		i(1, "description"),
		t "](",
		d(2, get_clipboard, {}),
		t ")",
		i(0),
	}),
}
