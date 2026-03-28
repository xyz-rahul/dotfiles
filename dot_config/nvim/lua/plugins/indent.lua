return {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    config = function()
        -- Define highlight groups before setup to prevent errors
        vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3b4252" })
        vim.api.nvim_set_hl(0, "IblScope", { fg = "#81a1c1" })

        require("ibl").setup({
            indent = {
                char = "│",
            },
            scope = {
                enabled = false,
            },
        })

        local hooks = require("ibl.hooks")
        hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
        hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
    end,
}
