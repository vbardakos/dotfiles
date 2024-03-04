require("mason").setup()
require("mason-lspconfig").setup()


mason_lsp = require("mason-lspconfig")

mason_lsp.setup( { ensure_installed = { "pyright", "rust_analyzer", "lua_ls" } })

--TODO : Create a proper function to add LSPs & their configs
