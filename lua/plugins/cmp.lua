-- REEMPLAZA TODO EL CONTENIDO de tu archivo lua/plugins/cmp.lua con esto:

return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
            "onsails/lspkind.nvim",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = {
                        border = "rounded",
                        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
                    },
                    documentation = {
                        border = "rounded",
                        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
                    },
                },
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        menu = {
                            buffer = "[Buffer]",
                            nvim_lsp = "[LSP]",
                            luasnip = "[LuaSnip]",
                            nvim_lua = "[Lua]",
                            latex_symbols = "[Latex]",
                            path = "[Path]",
                            codeium = "[AI]",
                        },
                    }),
                },
                -- ========== MAPEOS CORREGIDOS SIN CONFLICTOS ==========
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),

                    -- CAMBIO PRINCIPAL: Usar Ctrl+j/k en lugar de Tab
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    ["<C-k>"] = cmp.mapping.select_prev_item(),

                    -- Tab SOLO para snippets, NO para navegación
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback() -- Tab normal para indentación
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback() -- Shift+Tab normal
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "codeium" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),
            })

            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
            vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none", fg = "#3e4452" })

            print("✅ Autocompletado CORREGIDO - Usa Ctrl+j/k para navegar, Tab para indentar")
        end,
    },
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = {
            "rafamadriz/friendly-snippets",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local luasnip = require("luasnip")
            local types = require("luasnip.util.types")

            luasnip.config.set_config({
                history = true,
                updateevents = "TextChanged,TextChangedI",
                enable_autosnippets = true,
                ext_opts = {
                    [types.choiceNode] = {
                        active = {
                            virt_text = { { "•", "GruvboxOrange" } },
                        },
                    },
                    [types.insertNode] = {
                        active = {
                            virt_text = { { "•", "GruvboxBlue" } },
                        },
                    },
                },
                ft_func = function()
                    return vim.split(vim.bo.filetype, ".", true)
                end,
            })

            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets" } })
            require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets" })

            -- Cargar snippets específicos para PHP
            require("luasnip.loaders.from_vscode").lazy_load({
                paths = {
                    vim.fn.stdpath("config") .. "/php-snippets",
                },
            })

            -- ========== MAPEOS ALTERNATIVOS PARA SNIPPETS ==========
            vim.keymap.set({ "i", "s" }, "<C-l>", function()
                if luasnip.choice_active() then
                    luasnip.change_choice(1)
                end
            end, { desc = "Cambiar opción en snippet" })

            -- Ya no usamos Ctrl+k/j para snippets porque ahora son para CMP
            vim.keymap.set({ "i", "s" }, "<A-k>", function()
                if luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                end
            end, { desc = "Expandir o saltar al siguiente snippet" })

            vim.keymap.set({ "i", "s" }, "<A-j>", function()
                if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                end
            end, { desc = "Saltar al snippet anterior" })

            vim.keymap.set("i", "<C-u>", function()
                if luasnip.choice_active() then
                    luasnip.change_choice(1)
                end
            end, { desc = "Cambiar opción en snippet" })
        end,
    },
    {
        "Exafunction/codeium.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
        },
        config = function()
            require("codeium").setup({
                enable_chat = true,
            })

            vim.keymap.set("i", "<C-g>", function()
                return vim.fn["codeium#Accept"]()
            end, { expr = true, desc = "Codeium: Accept suggestion" })
            vim.keymap.set("i", "<c-;>", function()
                return vim.fn["codeium#CycleCompletions"](1)
            end, { expr = true, desc = "Codeium: Next suggestion" })
            vim.keymap.set("i", "<c-,>", function()
                return vim.fn["codeium#CycleCompletions"](-1)
            end, { expr = true, desc = "Codeium: Prev suggestion" })
            vim.keymap.set("i", "<c-x>", function()
                return vim.fn["codeium#Clear"]()
            end, { expr = true, desc = "Codeium: Clear suggestion" })
        end,
    },
}
