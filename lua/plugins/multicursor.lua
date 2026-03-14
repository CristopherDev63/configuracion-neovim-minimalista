return {
  "jake-stewart/multicursor.nvim",
  config = function()
    local mc = require("multicursor-nvim")

    mc.setup()

    local set = vim.keymap.set

    -- Add or skip cursor above/below
    set({"n", "v"}, "<C-Up>", function() mc.lineAddCursor(-1) end)
    set({"n", "v"}, "<C-Down>", function() mc.lineAddCursor(1) end)
    set({"n", "v"}, "<C-S-Up>", function() mc.lineSkipCursor(-1) end)
    set({"n", "v"}, "<C-S-Down>", function() mc.lineSkipCursor(1) end)

    -- Add and remove cursors by matching word (Using leader+d to avoid terminal conflicts)
    set({"n", "v"}, "<leader>d", function() mc.matchAddCursor(1) end)
    set({"n", "v"}, "<C-s>", function() mc.matchSkipCursor(1) end)
    set({"n", "v"}, "<leader>n", function() mc.matchAddCursor(-1) end)
    set({"n", "v"}, "<leader>s", function() mc.matchSkipCursor(-1) end)

    -- ADD CURSOR AT POS (Manualmente en puntos específicos)
    set({"n", "v"}, "<leader>x", mc.addCursor)
    
    -- DELETE CURRENT CURSOR (Por si pusiste uno de más)
    set({"n", "v"}, "<leader>q", mc.deleteCursor)

    -- Add all matches in the document
    set({"n", "v"}, "<leader>A", mc.matchAllAddCursors)

    -- Rotate the main cursor
    set({"n", "v"}, "<left>", mc.nextCursor)
    set({"n", "v"}, "<right>", mc.prevCursor)

    -- Clone cursors (like visual block mode)
    set("v", "<leader>c", mc.duplicateCursors)

    set("n", "<esc>", function()
        if not mc.cursorsEnabled() then
            mc.enableCursors()
        elseif mc.hasCursors() then
            mc.clearCursors()
        else
            -- Default <esc> behavior
        end
    end)

    -- Customize cursor look
    local hl = vim.api.nvim_set_hl
    hl(0, "MultiCursorCursor", { link = "Cursor" })
    hl(0, "MultiCursorVisual", { link = "Visual" })
    hl(0, "MultiCursorSign", { link = "SignColumn" })
    hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
    hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
  end
}
