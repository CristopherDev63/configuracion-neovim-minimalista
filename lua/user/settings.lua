-- user/settings.lua — Configuraciones personalizadas Nothing Edition
-- Ajustes específicos del usuario

local M = {}

-- Tamaño de fuente base (para referencias)
M.base_font_size = 14

-- Terminal preferida
M.preferred_terminal = "iterm2"  -- o "alacritty"

-- Límites de rendimiento Mac 2015
M.max_lsp_clients = 3
M.undo_levels = 100
M.gitsigns_debounce = 500

-- Modelos de IA (orden de prioridad)
M.ai_models = {
  primary = "openrouter/z-ai/glm-5.2",      -- GLM-5.2
  secondary = "openrouter/qwen/qwen-2.5-coder-32b-instruct",  -- Qwen
  tertiary = "opencode/big-pickle",           -- Big Pickle
}

return M
