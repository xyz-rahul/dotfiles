return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master", -- classic configs API; `main` is the rewrite without nvim-treesitter.configs
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                -- Automatically install missing parsers when entering buffer
                -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
                auto_install = true,
            })
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        opts = {},
    },
}
