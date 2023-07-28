vim.g.mapleader = ""
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })

vim.g.sqlite_clib_path = vim.fn.stdpath("config") .. "/bin/sqlite3.dll"

vim.lsp.set_log_level("debug")

require('cookie.globals')
require('cookie.options')

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


require("lazy").setup("custom.plugins", {
    ui = {
      icons = {
        cmd = "⌘",
        config = "🛠",
        event = "📅",
        ft = "📂",
        init = "⚙",
        keys = "🗝",
        plugin = "🔌",
        runtime = "💻",
        source = "📄",
        start = "🚀",
        task = "📌",
      },
    },
  })

-- require('cookie.plugins')

-- require('cookie.lsp')

-- require('cookie.telescope')
-- require('cookie.telescope.mappings')

if vim.g.neovide then
    vim.g.neovide_transparency = 1
    vim.g.neovide_refresh_rate = 60
    vim.g.neovide_fullscreen = false 
    vim.g.neovide_remember_window_size = true
    vim.g.neovide_cursor_trail_size = 0.0
    vim.g.neovide_cursor_animation_length = 0
    vim.g.neovide_scale_factor = 1.0
    local change_scale_factor = function(delta)
      vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
    end
    vim.keymap.set("n", "<C-=>", function()
      change_scale_factor(1.25)
    end)
    vim.keymap.set("n", "<C-->", function()
      change_scale_factor(1/1.25)
    end)
end

