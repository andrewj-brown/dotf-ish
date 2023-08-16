-- kill netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


-- bootstrap the package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)


-- GENERAL VIM SETTINGS
-- tabs are 2 spaces (chromium style)
vim.opt.expandtab = true
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- visual settings
vim.opt.number = true
vim.opt.ruler = true
vim.opt.background = "dark"
vim.opt.showmatch = true
vim.opt.wildmenu = true
vim.opt.cursorline = true


-- PLUGINS (VIA LAZY)
require("lazy").setup({
    {
        "romgrk/barbar.nvim",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
    },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
    },
    {
        "folke/tokyonight.nvim",
        version = "*",
        lazy = false,
        priority = 1000,
        opts = {},
    },
    {
        "neovim/nvim-lspconfig",
        version = "*",
        lazy = false,
        opts = {},
        config = function() end
    },
    {
        "hrsh7th/nvim-cmp",
        version = "*",
        lazy = false,
        opts = {},
        config = function() end
    },
    {
        "hrsh7th/cmp-nvim-lsp",
        version = "*",
        lazy = false,
        opts = {},
        config = function() end
    },
    {
        "hrsh7th/cmp-nvim-lsp-signature-help",
        version = "*",
        lazy = false,
        opts = {},
        config = function() end
    },
    {
        "hrsh7th/cmp-buffer",
        version = "*",
        lazy = false,
        opts = {},
        config = function() end
    },
    {
        "hrsh7th/cmp-path",
        version = "*",
        lazy = false,
        opts = {},
        config = function() end
    },
    {
        "prettier/vim-prettier",
        version = "*",
        lazy = false,
        opts = {},
        config = function() end,
        run = "yarn install --frozen-lockfile --production",
        ft = {"javascript", "typescript", "css", "scss", "json", "graphql", "markdown", "vue", "yaml", "html"}
    }
})

-- setup for barbar
vim.g.barbar_auto_setup = false
require("bufferline").setup({
    animation = true,
    auto_hide = false,
    focus_on_close = 'previous',
    icons = {
        buffer_index = true,
    },
    sidebar_filetypes = {
        NvimTree = true,
    }
});
-- setup for nvim-tree
require("nvim-tree").setup({
    sort_by = "name",
	view = {
	    width = 30,
    },
	filters = {
	    dotfiles = false,
	},
    modified = {
        enable = true,
    },
    renderer = {
        highlight_modified = "icon",
    },
    disable_netrw = true,
    hijack_cursor = true,
    hijack_unnamed_buffer_when_opening = false,
});
local lspconfig = require("lspconfig")
lspconfig.pyright.setup {}


-- fun trick to open nvim-tree (file explorer) on startup.
-- keep the cursor on the file if you're opening one
local function open_nvim_tree(data)
    if (vim.fn.filereadable(data.file) == 1) then
        require("nvim-tree.api").tree.toggle({ focus = false })
    else
        -- todo: if you're opening *nothing* (i.e. just `nvim`), replace the empty buffer
        -- instead of opening next to it
        require("nvim-tree.api").tree.open()
    end
    vim.api.nvim_exec_autocmds("BufWinEnter", {buffer = require("nvim-tree.view").get_bufnr()})
end
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })


-- theme
vim.cmd[[colorscheme tokyonight-moon]]
-- consider making custom colours if you're bored


-- barbar bindings
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
map('n', '<C-t>b', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<C-t>f', '<Cmd>BufferNext<CR>', opts)
map('n', '<C-t>1', '<Cmd>BufferGoto 1<CR>', opts)
map('n', '<C-t>2', '<Cmd>BufferGoto 2<CR>', opts)
map('n', '<C-t>3', '<Cmd>BufferGoto 3<CR>', opts)
map('n', '<C-t>4', '<Cmd>BufferGoto 4<CR>', opts)
map('n', '<C-t>5', '<Cmd>BufferGoto 5<CR>', opts)
map('n', '<C-t>6', '<Cmd>BufferGoto 6<CR>', opts)
map('n', '<C-t>7', '<Cmd>BufferGoto 7<CR>', opts)
map('n', '<C-t>8', '<Cmd>BufferGoto 8<CR>', opts)
map('n', '<C-t>9', '<Cmd>BufferGoto 9<CR>', opts)
map('n', '<C-t>p', '<Cmd>BufferPin<CR>', opts)
map('n', '<C-t>w', '<Cmd>BufferClose<CR>', opts)

-- other bindings
map('n', '<C-h>', '0', opts)    -- <C-h>            Home
map('n', '<C-e>', '$', opts)    -- <C-e>            End
                                -- <C-f>,           PageDown
                                -- <C-b>,           PageUp
                                -- <C-w><Left>,     Switch Window Left
                                -- <C-w><Right>,    Switch Window Right
map('n', '<C-d>', 'yyp', opts)  -- <C-d>            Duplicate Line
                                -- dd,     Delete Line
                                -- <C-w>s,          Split Window Horizontally
                                -- <C-w>v,          Split Window Vertically
