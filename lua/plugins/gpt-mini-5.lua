-- lua/plugins/gpt-mini-5.lua
-- Integración de GPT-4o Mini como fuente de autocompletado

local M = {}

function M.complete(request)
    -- Asegurarse de que solo se envíen datos serializables
    local prompt = request.context and request.context.cursor_line or ""
    local response = vim.fn.system(string.format("curl -s -X POST -H 'Content-Type: application/json' -d '{\"prompt\": \"%s\"}' http://localhost:5000/completions", vim.fn.json_encode(prompt)))
    local result = vim.fn.json_decode(response)

    if result and result.choices and #result.choices > 0 then
        return result.choices[1].text
    end

    return ""
end

return M
