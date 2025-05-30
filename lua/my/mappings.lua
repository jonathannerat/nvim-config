local utils = require("my.utils")
local config = utils.config

local find_files = config("cmd.find_files")
local find_files_hidden = config("cmd.find_files_hidden")
local find_files_vcs = config("cmd.find_files_vcs")
local find_files_all = config("cmd.find_files_all")

utils.map({
	{
		group = { silent = true },
		{
			"<ESC>",
			vim = "nohlsearch",
			desc = "Clear search results",
		},
		{
			"<LEADER>Qa",
			vim = "quitall!",
			desc = "Force quit all",
		},
		{ "<LEADER>Q", vim = "quit!", desc = "Force quit" },
		{
			"<LEADER>r",
			vim = "e %",
			desc = "Reload current buffer",
		},
		{
			"<C-w>m",
			"<C-w>_<C-w>|",
			desc = "Maximize current window",
		},
		{
			"<M-j>",
			":m .+1<CR>==",
			desc = "Move current line down",
		},
		{
			"<M-k>",
			":m .-2<CR>==",
			desc = "Move current line up",
		},
		{
			"g<",
			vim = "tabmove-",
			desc = "Move current tab left",
		},
		{
			"g>",
			vim = "tabmove+",
			desc = "Move current tab right",
		},
		{
			"<LEADER>qa",
			vim = "quitall",
			desc = "Quit all",
		},
		{
			"<LEADER>q",
			vim = "quit",
			desc = "Quit",
		},
		{
			"<LEADER>w",
			vim = "write",
			desc = "Save",
		},
		{
			"<SPACE>",
			disable = true,
			desc = "Disable default <SPACE> mapping",
		},
	},
	-- Mappings of third party plugins
	{
		group = { silent = true },
		{
			"g<Tab>",
			"<Plug>(snippy-cut-text)",
			desc = "Start snippet completion with text-object",
		},
		{
			"<Tab>",
			"<Plug>(snippy-cut-text)",
			mode = "x",
			desc = "Start snippet completion with selected text",
		},
		{
			"<leader>bf",
			vim = "Format",
			desc = "Format buffer",
		},
		{
			"<leader>bF",
			vim = "FormatWrite",
			desc = "Format and write buffer",
		},
		{
			"<leader>m",
			vim = "TSJToggle",
			desc = "Toggle split/join of secuencial blocks of code (arrays, maps, etc.)",
		},
		{
			"<leader>s",
			vim = "SnippyEdit",
			desc = "Edit snippets for current filetype",
		},
		{
			"<leader>tt",
			lua = "require('neotest').run.run()",
			desc = "Run tests for current project",
		},
		{
			"<leader>tf",
			lua = "require('neotest').run.run(vim.api.nvim_buf_get_name(0))",
			desc = "Run tests for current file",
		},
		{
			"<leader>to",
			lua = "require('neotest').output.open{ enter = true, last_run = true }",
			desc = "Show output of last tests",
		},
		{
			"<M-o>",
			function()
				require("oil").toggle_float()
			end,
		},
		{
			"<leader>fb",
			vim = "Telescope buffers",
			desc = "Find open buffers",
		},
		{
			"<leader>ff",
			function()
				require("telescope.builtin").find_files({
					layout_config = { preview_cutoff = 120 },
					find_command = find_files,
				})
			end,
			desc = "Find files",
		},
		{
			"<leader>fH",
			function()
				require("telescope.builtin").find_files({
					layout_config = { preview_cutoff = 120 },
					find_command = find_files_hidden,
				})
			end,
			desc = "Find files including hidden",
		},
		{
			"<leader>fG",
			function()
				require("telescope.builtin").find_files({
					layout_config = { preview_cutoff = 120 },
					find_command = find_files_vcs,
				})
			end,
			desc = "Find files including VCS ignored files",
		},
		{
			"<leader>fF",
			function()
				require("telescope.builtin").find_files({
					layout_config = { preview_cutoff = 120 },
					find_command = find_files_all,
				})
			end,
			desc = "Find ALL files",
		},
		{
			"<leader>fg",
			function()
				require("telescope").extensions.live_grep_args.live_grep_args({
					layout_config = { prompt_position = "top" },
					layout_strategy = "vertical",
				})
			end,
			desc = "Search text using regex in all files",
		},
		{
			"<leader>fh",
			vim = "Telescope help_tags",
			desc = "Find vim help tags",
		},
		{
			"<leader>fm",
			vim = "Telescope man_pages",
			desc = "Find man pages",
		},
		{
			"<leader>fo",
			vim = "Telescope oldfiles",
			desc = "Find man old files",
		},
		{
			"<leader>fr",
			vim = "Telescope resume",
			desc = "Resume last find",
		},
		{
			"<leader>ft",
			vim = "Telescope treesitter",
			desc = "Find treesitter elements",
		},
		{
			"<leader>n",
			lua = "require('notify').dismiss()",
		},
		{
			"<leader>cc",
			vim = "TSContextToggle",
			desc = "Toggle treesitter context",
		},
		{
			"<M-t>",
			function ()
            require("FTerm").toggle()
			end,
			desc = "Toggle floating terminal",
			mode = { "normal", "terminal" },
		},
	},
	{
		group = { mode = "insert", silent = true },
		{
			"<M-j>",
			"<ESC>:m .+1<CR>==gi",
			desc = "Move current line down",
		},
		{
			"<M-k>",
			"<ESC>:m .-2<CR>==gi",
			desc = "Move current line up",
		},
		{ "jk", "<ESC>" },
	},
	{
		group = { mode = "visual", silent = true },
		{
			"/",
			[[<ESC>/\%V]],
			desc = "Forward search inside selected region",
		},
		{
			"?",
			[[<ESC>?\%V]],
			desc = "Backward search inside selected region",
		},
		{
			"<M-j>",
			":m '>+1<CR>gv=gv",
			desc = "Move selected lines down",
		},
		{
			"<M-k>",
			":m '<-2<CR>gv=gv",
			desc = "Move selected lines up",
		},
	},
	{
		group = { mode = "command", silent = true },
		{ "<C-j>", "<DOWN>" },
		{ "<C-k>", "<UP>" },
	},
})

local lazygit = require("FTerm"):new {
   cmd = "lazygit",
   ft = "LazygitFTerm"
}

utils.map {
   {
      "<M-g>",
      function() lazygit:toggle() end,
      mode = { "normal", "terminal" },
      desc = "Open floating lazygit terminal"
   }
}
