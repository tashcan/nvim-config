local Remap = require("cookie.keymap")
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap
local inoremap = Remap.inoremap
local xnoremap = Remap.xnoremap

xnoremap("<leader>p", "\"_dP") -- Paste without replacing paste buffer
vnoremap("<leader>d", "\"_d") -- Delete without replacing paste buffer

nnoremap("Y", "yg$")
nnoremap("<leader>y", "\"+y")
vnoremap("<leader>y", "\"+y")

inoremap("<C-c>", "<Esc>") -- REEEEEE