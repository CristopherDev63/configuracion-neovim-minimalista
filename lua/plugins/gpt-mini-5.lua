-- lua/plugins/gpt-mini-5.lua
-- Integración de GPT-5o Mini como fuente de autocompletado

local M = {}

function M.complete(request)
    local response = vim.fn.system(string.format("curl -s -X POST -H 'Content-Type: application/json' -d '%s' http://localhost:5000/completions", vim.fn.json_encode(request)))
    local result = vim.fn.json_decode(response)

    if result and result.choices and #result.choices > 0 then
        return result.choices[1].text
    end

    return ""
end

return M
