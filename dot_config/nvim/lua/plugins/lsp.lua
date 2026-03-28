return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		opts = {},
	},
	-- LSP
	{
		"neovim/nvim-lspconfig",
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "saghen/blink.cmp" },
		},
		init = function()
			-- Reserve a space in the gutter
			-- This will avoid an annoying layout shift in the screen
			vim.opt.signcolumn = "yes"
		end,
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls", --  Lua
					"bashls", --  Bash
					"ts_ls", --  JS/TS
					"yamlls", --  YAML
					"dockerls", --  Docker
					"docker_compose_language_service", --  Docker-Compose
					"html", --  HTML
					"cssls", --  CSS
					"emmet_ls", --  Emmet           (HTML/CSS  snippets)
					"vimls", --  Vimscript
					"tailwindcss", --  TailwindCSS
					"gradle_ls", --  Gradle
					"jdtls", --  Java
					"ast_grep",
					"pyright",
				},
				handlers = {
					function(server_name)
						require("lspconfig")[server_name].setup({ capabilities = capabilities })
					end,

					lua_ls = function()
						require("lspconfig").lua_ls.setup({
							capabilities = capabilities,
							single_file_support = true,
							root_dir = function(fname)
								local util = require("lspconfig.util")
								local nvim_config = vim.fn.stdpath("config")

								-- If file is in nvim config, use that as root
								if fname:match(vim.pesc(nvim_config)) then
									return nvim_config
								end

								-- Otherwise use file's directory (not git root)
								return util.path.dirname(fname)
							end,
							settings = {
								Lua = {
									runtime = {
										version = "LuaJIT",
									},
									diagnostics = {
										globals = { "vim" },
									},
									workspace = {
										checkThirdParty = false,
										ignoreDir = { ".git", "node_modules", vim.env.HOME },
										library = {
											vim.env.VIMRUNTIME,
										},
									},
									telemetry = {
										enable = false,
									},
								},
							},
						})
					end,

					--  Custom handler for basedpyright
					basedpyright = function()
						require("lspconfig").basedpyright.setup({
							settings = {
								basedpyright = {
									analysis = {
										diagnosticMode = "openFilesOnly",
										inlayHints = {
											callArgumentNames = true,
										},
									},
								},
							},
						})
					end,
				},
			})
		end,
	},
	-- autopairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"giuxtaposition/blink-cmp-copilot",
			"zbirenbaum/copilot.lua",
		},
		version = "1.*",
		opts = {
			keymap = { preset = "default", ["<CR>"] = { "accept", "fallback" } },
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			-- Displays a preview of the selected item on the current line
			signature = { enabled = true },
			sources = {
				default = {
					"lsp",
					"path",
					"snippets",
					"buffer",
					"copilot",
				},
				providers = {
					copilot = {
						name = "copilot",
						module = "blink-cmp-copilot",
						score_offset = 50,
						async = true,
						transform_items = function(ctx, items)
							for _, item in ipairs(items) do
								item.kind_icon = ""
								item.kind_name = "Copilot"
							end
							return items
						end,
					},
				},
			},
		},
	},
	{
		"zbirenbaum/copilot.lua",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
				server_opts_overrides = {
					trace = "verbose",
					settings = {
						advanced = {
							listCount = 10, -- #completions for panel
							inlineSuggestCount = 3, -- #completions for getCompletions
						},
					},
				},
				workspace_folders = {
					"~/dev/workspace/",
					"~/.dotfiles/",
				},
			})
		end,
	},
}
