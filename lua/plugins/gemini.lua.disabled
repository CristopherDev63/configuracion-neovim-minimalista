return {
  "kiddos/gemini.nvim",
  config = function()
    require("gemini").setup({
      api_key = os.getenv("GEMINI_API_KEY"),
      completion = {
        insert_result_key = "<C-l>",
      },
    })
    print("✅ Gemini (inline) loaded.")
  end,
}
