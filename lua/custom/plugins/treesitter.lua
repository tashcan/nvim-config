local enabled = true

local custom_captures = {
    -- highlight own capture @foo.bar with highlight group "Identifier", see :h nvim-treesitter-query-extensions
    ['foo.bar'] = 'Identifier',
    ['function.call'] = 'LuaFunctionCall',
    ['function.bracket'] = 'Type',

    ['namespace.type'] = 'TSNamespaceType'
}

vim.cmd [[highlight IncludedC guibg=#373b41]]

return {
    {
      "nvim-treesitter/nvim-treesitter",
      config = function()
        require('nvim-treesitter.configs').setup {
            ensure_installed = {'go', 'cpp', 'c', 'rust', 'toml', 'query', 'typescript', 'svelte', 'markdown'},
        
            highlight = {
                enable = enabled, -- false will disable the whole extension
                use_languagetree = false,
                disable = {"json"},
                custom_captures = custom_captures
            },
        
            incremental_selection = {
                enable = enabled,
                keymaps = { -- mappings for incremental selection (visual mappings)
                    init_selection = '<M-w>', -- maps in normal mode to init the node/scope selection
                    node_incremental = '<M-w>', -- increment to the upper named parent
                    scope_incremental = '<M-e>', -- increment to the upper scope (as defined in locals.scm)
                    node_decremental = '<M-C-w>' -- decrement to the previous node
                }
            },
        
            refactor = {
                highlight_definitions = {enable = enabled},
                highlight_current_scope = {enable = false},
        
                smart_rename = {
                    enable = false,
                    keymaps = {
                        -- mapping to rename reference under cursor
                        smart_rename = 'grr'
                    }
                },
        
                -- TODO: This seems broken...
                navigation = {
                    enable = false,
                    keymaps = {
                        goto_definition = 'gnd', -- mapping to go to definition of symbol under cursor
                        list_definitions = 'gnD' -- mapping to list all definitions in current file
                    }
                }
            }
        }
      end,
    },
    { dir = "~/plugins/tree-sitter-lua" },
  }