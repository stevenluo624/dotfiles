-- ~/.config/nvim/lua/tianyu/plugins/lsp/lspconfig.lua
-- Updated for Neovim 0.11+ using vim.lsp.config
return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig", -- Keep this for mason-lspconfig compatibility
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{
			"folke/lazydev.nvim", -- Modern replacement for neodev
			ft = "lua",
			opts = {
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},
	config = function()
		-- 1. Require necessary modules
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local keymap = vim.keymap

		-- 2. Define LSP capabilities
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- 3. Define your on_attach function
		local on_attach = function(client, bufnr)
			local opts = { buffer = bufnr, silent = true, noremap = true }
			opts.desc = "Show LSP references"
			keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
			opts.desc = "Go to declaration"
			keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			opts.desc = "Go to definition"
			keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			opts.desc = "Show hover"
			keymap.set("n", "K", vim.lsp.buf.hover, opts)
			opts.desc = "Go to implementation"
			keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
			opts.desc = "Show signature help"
			keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
			opts.desc = "Add workspace folder"
			keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
			opts.desc = "Remove workspace folder"
			keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
			opts.desc = "List workspace folders"
			keymap.set("n", "<space>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, opts)
			opts.desc = "Go to type definition"
			keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
			opts.desc = "Rename symbol"
			keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
			opts.desc = "Show code actions"
			keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
			opts.desc = "Format code"
			keymap.set({ "n", "v" }, "<space>f", function()
				vim.lsp.buf.format({
					async = true,
					filter = function(c)
						return c.supports_method("textDocument/formatting")
					end,
				})
			end, opts)

			if client.server_capabilities.documentHighlightProvider then
				vim.api.nvim_create_augroup("LspDocumentHighlightTianyu", { clear = true })
				vim.api.nvim_clear_autocmds({ group = "LspDocumentHighlightTianyu", buffer = bufnr })
				vim.api.nvim_create_autocmd("CursorHold", {
					group = "LspDocumentHighlightTianyu",
					buffer = bufnr,
					callback = vim.lsp.buf.document_highlight,
				})
				vim.api.nvim_create_autocmd("CursorMoved", {
					group = "LspDocumentHighlightTianyu",
					buffer = bufnr,
					callback = vim.lsp.buf.clear_references,
				})
			end
		end

		-- 4. Configure global diagnostic settings
		vim.diagnostic.config({
			virtual_text = true,
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})

		-- 5. Customize hover and signature help popups
		local default_border = "rounded"
		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = default_border })
		vim.lsp.handlers["textDocument/signatureHelp"] =
			vim.lsp.with(vim.lsp.handlers.signature_help, { border = default_border })

		-- 6. Setup Mason
		mason.setup()

		-- 7. Setup Mason-LSPConfig
		mason_lspconfig.setup({
			ensure_installed = {
				"lua_ls",
				"pyright",
			},
		})

		-- 8. Configure lua_ls using new vim.lsp.config API
		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					telemetry = { enable = false },
				},
			},
		})

		-- 9. Configure pyright using new vim.lsp.config API
		vim.lsp.config("pyright", {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				python = {
					analysis = {
						typeCheckingMode = "basic",
					},
				},
			},
		})

		-- 10. Auto-configure other installed servers
		local installed_servers = mason_lspconfig.get_installed_servers()
		for _, server in ipairs(installed_servers) do
			if server ~= "lua_ls" and server ~= "pyright" then
				vim.lsp.config(server, {
					capabilities = capabilities,
					on_attach = on_attach,
				})
			end
		end

		-- 11. Enable LSP for configured filetypes
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "*",
			callback = function(args)
				vim.lsp.enable("lua_ls")
				vim.lsp.enable("pyright")
				-- Enable other servers
				for _, server in ipairs(installed_servers) do
					if server ~= "lua_ls" and server ~= "pyright" then
						vim.lsp.enable(server)
					end
				end
			end,
		})

		-- 12. Final diagnostic configuration
		vim.diagnostic.config({
			virtual_text = false,
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})
	end,
}
