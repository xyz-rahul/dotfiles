return {
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim", -- optional for ensuring tools
		opts = {
			ensure_installed = {
				"stylua",
				"prettier",
				"prettierd",
				"ruff",
			},
		},
	},
	{
		"stevearc/conform.nvim",
		init = function()
			vim.o.formatexpr = [[v:lua.require("conform").formatexpr()]]
		end,
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "ruff_format", "ruff_organize_imports", stop_after_first = true },
					javascript = { "prettierd", "prettier", stop_after_first = true },
					typescript = { "prettierd", "prettier", stop_after_first = true },
					html = { "prettierd", "prettier", stop_after_first = true },
					css = { "prettierd", "prettier", stop_after_first = true },
				},
			})
			vim.keymap.set({ "n", "v" }, "<leader>fm", function()
				require("conform").format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				})
			end, { desc = "Format file or range (in visual mode)" })
		end,
	},
}
