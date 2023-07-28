vim.opt.termguicolors = true
vim.opt.background = 'dark'

return {
    {
        "Yagua/nebulous.nvim",
        config = function()
            require('nebulous').setup({
                disable = {
                    background = true,
                },
            })
        end
    }
}
