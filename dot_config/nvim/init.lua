vim.cmd([[source ~/.vimrc]])
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("$HOME") .. "/.nvim/undodir"

vim.diagnostic.config({
	underline = true,
	signs = true,
	virtual_text = false,
	float = {
		focusable = true,
		show_header = true,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})

vim.keymap.set("n", "<C-e>", "<cmd>Explore<cr>")
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "go", vim.lsp.buf.type_definition)
vim.keymap.set("n", "gs", vim.lsp.buf.signature_help)
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)
vim.keymap.set({ "n", "x" }, "=", function()
	vim.lsp.buf.format({ async = true })
end)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>dt", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end)
vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist)
vim.keymap.set("n", "[d", vim.diagnostic.goto_next)
vim.keymap.set("n", "]d", vim.diagnostic.goto_prev)

-- Close quickfix/location list when selecting an item
vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	callback = function()
		local buf = vim.api.nvim_get_current_buf()
		local function close_qf()
			-- Check if it's a location list or quickfix list
			local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
			if wininfo and wininfo.loclist == 1 then
				vim.cmd("lclose")
			else
				vim.cmd("cclose")
			end
		end

		-- Close when pressing Enter
		vim.keymap.set("n", "<CR>", function()
			vim.cmd("normal! <CR>")
			vim.defer_fn(close_qf, 100)
		end, { buffer = buf })

		-- Close on double-click
		vim.keymap.set("n", "<2-LeftMouse>", function()
			vim.cmd("normal! <CR>")
			vim.defer_fn(close_qf, 100)
		end, { buffer = buf })
	end,
})

-- Close quickfix when leaving it to jump to a file
vim.api.nvim_create_autocmd("WinLeave", {
	callback = function()
		local win = vim.api.nvim_get_current_win()
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == "qf" then
			vim.defer_fn(function()
				-- Only close if we're now in a different window
				local current_win = vim.api.nvim_get_current_win()
				if current_win ~= win then
					vim.cmd("cclose")
					vim.cmd("lclose")
				end
			end, 50)
		end
	end,
})

vim.opt.termguicolors = true
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	-- automatically check for plugin updates
	checker = { enabled = true, notify = false },
})
