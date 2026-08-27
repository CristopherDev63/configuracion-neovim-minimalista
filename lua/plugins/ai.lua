-- plugins/ai.lua — Integración IA con OpenCode
-- Vibe coding: chat con IA que puede ver y editar tu código

return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  cmd = { "OpenCode", "OpenCodeChat" },
  keys = {
    { "<leader>ic", function() require("opencode").toggle() end, mode = "n", desc = "Chat con IA" },
    { "<leader>ia", function() require("opencode").ask("@this: ", { submit = true }) end, mode = { "n", "x" }, desc = "Enviar a IA" },
    { "<leader>ie", function() require("opencode").ask("@this: Explica este código de forma clara y concisa", { submit = true }) end, mode = { "n", "x" }, desc = "Explicar código" },
    { "<leader>ir", function() require("opencode").ask("@this: Refactoriza este código para que sea más limpio, mantenible y siga buenas prácticas", { submit = true }) end, mode = { "n", "x" }, desc = "Refactorizar" },
    { "<leader>id", function() require("opencode").ask("@this: Documenta este código con comentarios claros y precisos", { submit = true }) end, mode = { "n", "x" }, desc = "Documentar" },
    { "<leader>it", function() require("opencode").ask("@this: Genera tests unitarios completos para este código", { submit = true }) end, mode = { "n", "x" }, desc = "Generar tests" },
    { "<leader>if", function() require("opencode").ask("@this: Encuentra y arregla los errores en este código", { submit = true }) end, mode = { "n", "x" }, desc = "Arreglar errores" },
    { "<leader>ii", function() require("opencode").ask("@this: Implementa el siguiente código basado en esta selección o contexto", { submit = true }) end, mode = { "n", "x" }, desc = "Insertar código IA" },
    { "<leader>io", function() require("opencode").ask("@this: Optimiza este código para mejor rendimiento y legibilidad", { submit = true }) end, mode = { "n", "x" }, desc = "Optimizar" },
  },
  opts = {},
}
