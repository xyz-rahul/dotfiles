return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        -- calling `setup` is optional for customization
        require("fzf-lua").setup({ "fzf-native" })
        -- Set key mappings using vim.api.nvim_set_keymap
        vim.api.nvim_set_keymap(
            "n",
            "<leader>ff",
            "<cmd>lua require('fzf-lua').files({ fzf_opts = {['--layout'] = 'reverse-list'} })<cr>",
            { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap(
            "n",
            "<leader>lg",
            "<cmd>lua require'fzf-lua'.live_grep()<cr>",
            { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap(
            "n",
            "<leader>gg",
            "<cmd> lua require'fzf-lua'.live_grep({ cmd = 'git grep --line-number --column --color=always' })<cr>",
            { noremap = true, silent = true }
        )
    end,
}
