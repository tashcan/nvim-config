return {
    {
        "nvim-tree/nvim-web-devicons",
        config = function ()
            require('nvim-web-devicons').setup {
                override = {
                zsh = {
                icon = "",
                color = "#428850",
                name = "Zsh"
                },
                fish = {
                icon = "",
                color = "#428850",
                name = "Fish"
                }
                };
                default = true;
            }           
        end
    }
  }