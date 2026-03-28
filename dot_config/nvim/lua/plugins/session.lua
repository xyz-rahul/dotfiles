return {
    "rmagatti/auto-session",
    lazy = false,
    opts = {
        auto_save = true,
        auto_restore = false,
        auto_create = true,
        log_level = "info",
        show_auto_restore_notif = false,
        -- Don't save/restore in these dirs (avoid clutter)
        suppressed_dirs = { "~/", "~/Downloads", "/" },
        session_lens = {
            load_on_setup = false,
        },
    },
    config = function(_, opts)
        -- Restore buffers, tabs, windows, folds, size, position
        vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
        require("auto-session").setup(opts)
    end,
}
