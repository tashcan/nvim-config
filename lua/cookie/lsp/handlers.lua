-- vim.lsp.handlers["textDocument/definition"] =
--     function(_, _, result)
--         if not result or vim.tbl_isempty(result) then
--             print("[LSP] Could not find definition")
--             return
--         end

--         if vim.tbl_islist(result) then
--             vim.lsp.util.jump_to_location(result[1])
--         else
--             vim.lsp.util.jump_to_location(result)
--         end
--     end

-- vim.lsp.handlers["textDocument/hover"] = require('lspsaga.hover').handler

-- local saga_config = require('lspsaga').config_values
-- saga_config.rename_prompt_prefix = '>'
