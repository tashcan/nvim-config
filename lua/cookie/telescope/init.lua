if not pcall(require, 'telescope') then return end

local should_reload = true
local reloader = function()
    if should_reload then
        RELOAD('plenary')
        RELOAD('telescope')
    end
end

reloader()

local actions = require('telescope.actions')
local sorters = require('telescope.sorters')
local themes = require('telescope.themes')

require('telescope').setup {
    defaults = {
        prompt_prefix = '❯ ',
        selection_caret = '❯ ',

        winblend = 0,

        layout_strategy = 'horizontal',

        selection_strategy = "reset",
        sorting_strategy = "descending",
        scroll_strategy = "cycle",
        layout_config = {
            horizontal = {
                width_padding = 0.1,
                height_padding = 0.1,
                preview_width = 0.6
            },
            vertical = {
                width_padding = 0.05,
                height_padding = 1,
                preview_height = 0.5
            },
            prompt_position = "top",
            preview_cutoff = 120,
        },
        color_devicons = true,

        mappings = {
            i = {
                ["<C-x>"] = false,
                ["<C-s>"] = actions.select_horizontal,
                ["<C-d>"] = actions.select_vertical
            }
        },

        borderchars = {'─', '│', '─', '│', '╭', '╮', '╯', '╰'},

        file_sorter = sorters.get_fzy_sorter,

        file_previewer = require('telescope.previewers').vim_buffer_cat.new,
        grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
        qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new
    },

    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true
        },

        fzf_writer = {use_highlighter = false, minimum_grep_characters = 6},
    }
}

-- Load the fzy native extension at the start.
pcall(require('telescope').load_extension, "fzy_native")

local M = {}

function M.fd() 
    opts = opts or {}
    local lspconfig = require('lspconfig')
    local root_dir = lspconfig.util.root_pattern('.p4config')
    local p4_dir = root_dir(vim.fn.getcwd():gsub('\\', '/'))

    -- Check for TnT so we can limit the search
    local engine_dir = lspconfig.util.path.join(p4_dir, 'TnT/Code/Engine'):gsub('\\', '/')
    local is_fb = lspconfig.util.path.is_dir(lspconfig.util.path.join(p4_dir, 'TnT/Code/Engine'))
    if is_fb then
        local engine_dir_strip = engine_dir:sub(vim.fn.getcwd():gsub('\\', '/'):len() + 2)
        print(engine_dir, vim.fn.getcwd():gsub('\\', '/'), engine_dir_strip)
        opts.find_command = { 'fd', '--type', 'file', '--search-path', engine_dir_strip, '-e', 'h', '-e', 'cpp', '-e', 'c', '-e', 'ddf', '--color', 'never' }
    else
        opts.find_command = { 'fd', '--type', 'file', '--color', 'never' }
    end
    require('telescope.builtin').find_files(opts)
end

function M.builtin() require('telescope.builtin').builtin() end

function M.git_files()
    local opts = themes.get_dropdown {
        winblend = 10,
        border = true,
        previewer = false
    }

    require('telescope.builtin').git_files(opts)
end

function M.buffer_git_files()
    require('telescope.builtin').git_files(
        themes.get_dropdown {
            cwd = vim.fn.expand("%:p:h"),
            winblend = 10,
            border = true,
            previewer = false
        })
end

function M.lsp_code_actions()
    local opts = themes.get_dropdown {
        winblend = 10,
        border = true,
        previewer = false
    }

    require('telescope.builtin').lsp_code_actions(opts)
end

function M.live_grep()
    require('telescope.builtin').live_grep {
        path_display = {shorten = 4},
        previewer = false,
        fzf_separator = "|>"
    }
end 

function M.live_grep_cpp()
    require('telescope.builtin').live_grep {
        path_display = {shorten = 4},
        previewer = false,
        type_filter = 'cpp',
        fzf_separator = "|>"
    }
end 


function M.grep_prompt()
    require('telescope.builtin').grep_string {
        path_display = {'shorten'},
        search = vim.fn.input("Grep String > ")
    }
end

function M.grep_last_search(opts)
    opts = opts or {}

    -- \<getreg\>\C
    -- -> Subs out the search things
    local register = vim.fn.getreg('/'):gsub('\\<', ''):gsub('\\>', ''):gsub(
                         "\\C", "")

    opts.path_display = {'shorten'}
    opts.word_match = '-w'
    opts.search = register

    require('telescope.builtin').grep_string(opts)
end

function M.buffers() require('telescope.builtin').buffers {} end

function M.curbuf()
    local opts = themes.get_dropdown {
        winblend = 10,
        border = true,
        previewer = false
    }
    require('telescope.builtin').current_buffer_fuzzy_find(opts)
end

function M.help_tags()
    require('telescope.builtin').help_tags {show_version = true}
end

function M.search_all_files(opts)
    require('telescope.builtin').find_files {
        find_command = { 'fd', '--type', 'file', '--no-ignore'}
    }
end

function M.file_browser()
    require('telescope.builtin').file_browser {
        sorting_strategy = 'ascending',
        scroll_strategy = 'cycle',
        prompt_position = 'top'
    }
end

function M.frecency()
    require('telescope').extensions.frecency.frecency {
        workspace = 'CWD'
    }
end

return setmetatable({}, {
    __index = function(_, k)
        reloader()

        if M[k] then
            return M[k]
        else
            return require('telescope.builtin')[k]
        end
    end
})
