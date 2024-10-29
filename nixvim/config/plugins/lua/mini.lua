--Mini Indentscope
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "dbui", "terminal", "help", "alpha", "dashboard", "trouble", "lazy", "mason", "nofile" },
    callback = function()
        vim.b.miniindentscope_disable = true
    end,
})
vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        vim.b.miniindentscope_disable = true
    end,
})

-- Mini BufDelete
local function bufdelete(force)
    return function()
        MiniBufremove.delete(nil, force)
    end
end
vim.keymap.set("n", "<leader>bd", bufdelete(false), { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>bD", bufdelete(true), { desc = "Force delete buffer" })

-- Mini Files Vinegar minus
local function mini_minus()
    MiniFiles.open(vim.api.nvim_buf_get_name(0))
end
vim.keymap.set("n", "-", mini_minus, { desc = "Open Mini Files over current file" })

-- Mini Files explorer buffer customization
local show_dotfiles = true
local filter_show = function(fs_entry)
    return true
end
local filter_hide = function(fs_entry)
    return not vim.startswith(fs_entry.name, ".")
end
local toggle_dotfiles = function()
    show_dotfiles = not show_dotfiles
    local new_filter = show_dotfiles and filter_show or filter_hide
    MiniFiles.refresh({ content = { filter = new_filter } })
end
local function mini_enter()
    MiniFiles.go_in({ close_on_file = true })
end
local function map_split(buf_id, lhs, direction)
    local rhs = function()
        -- Make new window and set it as target
        local new_target_window
        local exp_target_window = MiniFiles.get_explorer_state().target_window
        vim.api.nvim_win_call(exp_target_window, function()
            vim.cmd(direction .. " split")
            new_target_window = vim.api.nvim_get_current_win()
        end)

        MiniFiles.set_target_window(new_target_window)
        mini_enter()
    end

    -- Adding `desc` will result into `show_help` entries
    local desc = "Split " .. direction
    vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
end
vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesBufferCreate",
    callback = function(args)
        local buf_id = args.data.buf_id
        vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id })
        vim.keymap.set("n", "-", MiniFiles.go_out, { buffer = buf_id })
        vim.keymap.set("n", "<CR>", mini_enter, { buffer = buf_id })
        map_split(buf_id, "<C-x>", "belowright horizontal")
        map_split(buf_id, "<C-v>", "belowright vertical")
    end,
})

-- Mini Pick
vim.ui.select = require("mini.pick").ui_select
