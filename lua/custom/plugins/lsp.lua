return {
    {
      "neovim/nvim-lspconfig",
      config = function()
        require "cookie.lsp"
      end,
    },
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "simrat39/inlay-hints.nvim",
    "j-hui/fidget.nvim",
    "folke/neodev.nvim",
    "jose-elias-alvarez/null-ls.nvim",
    "jose-elias-alvarez/nvim-lsp-ts-utils",
    "nvim-lua/lsp-status.nvim",
    "onsails/lspkind-nvim",
    {
        'glepnir/lspsaga.nvim',
        config = function()
            local saga = require("lspsaga")
            saga.setup({})
        end,
        dependencies = {
            {"nvim-tree/nvim-web-devicons"},
            {"nvim-treesitter/nvim-treesitter"}
        }
    }
  }