-- lua/plugins/gpt-autocomplete.lua
-- Integración de GPT-4o Mini como fuente de autocompletado

local M = {}
local http = require("socket.http")  -- Asegúrate de tener la biblioteca socket instalada
local ltn12 = require("ltn12")

function M.complete(request)
    local prompt = request.context and request.context.cursor_line or ""
    local response_body = {}

    -- Configurar la solicitud HTTP
    local res, code, response_headers, status = http.request{
        url = "http://localhost:5000/completions",
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json",
        },
        source = ltn12.source.string(vim.fn.json_encode({ prompt = prompt })),
        sink = ltn12.sink.table(response_body),
    }

    -- Manejar la respuesta
    if code == 200 then
        local result = vim.fn.json_decode(table.concat(response_body))
        if result and result.choices and #result.choices > 0 then
            return result.choices[1].text
        end
    else
        print("Error en la solicitud: " .. tostring(code))
    end

    return ""
end

return M
