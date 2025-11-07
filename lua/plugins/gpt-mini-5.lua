-- lua/plugins/gpt-mini-5.lua

local cmp = require("cmp")
local api = require("cmp.utils.api")

local M = {}

-- Esta es la función que se llamará para obtener las completiciones.
-- @param params table: Parámetros de la petición de completado.
-- @param callback function: Función a la que se le pasan las completiciones.
function M.complete(params, callback)
  -- Obtenemos el texto antes del cursor.
  local cursor_before = api.get_cursor_before_line()

  -- PREPARAR LA LLAMADA A LA API
  -- =============================
  -- Aquí debes construir el cuerpo de la petición para tu API.
  -- Usaremos `curl` para hacer la llamada HTTP.
  --
  -- AJUSTA ESTOS VALORES:
  local api_endpoint = "http://localhost:5000/complete" -- <-- TU ENDPOINT DE LA API
  local api_key = os.getenv("OPENAI_API_KEY") -- Opcional: si usas una API key

  -- Ejemplo de cuerpo de la petición en formato JSON.
  -- La API debería recibir el texto y devolver una lista de sugerencias.
  local request_body = vim.fn.json_encode({
    prompt = cursor_before,
    max_tokens = 50, -- Ajusta según necesites
  })

  -- CONSTRUIR EL COMANDO CURL
  -- =========================
  local curl_cmd = {
    "curl",
    "-s", -- Modo silencioso
    "-X",
    "POST",
    api_endpoint,
    "-H",
    "Content-Type: application/json",
    -- La siguiente línea envía tu API key en la cabecera de autorización
    "-H", "Authorization: Bearer " .. api_key,
    "-d",
    request_body,
  }

  -- EJECUTAR LA LLAMADA ASÍNCRONA
  -- =============================
  vim.fn.jobstart(curl_cmd, {
    on_stdout = function(_, data)
      -- `data` es una tabla de strings. Concatenar y verificar que no esté vacío.
      if data and data[1] and data[1] ~= "" then
        local full_data = table.concat(data, "")
        
        -- Usar una llamada protegida para decodificar el JSON
        local ok, response = pcall(vim.fn.json_decode, full_data)
        if not ok or not response then
          -- No hacer nada si el JSON es inválido
          return
        end

        if response and response.completions then
          local completions = {}
          for _, text in ipairs(response.completions) do
            table.insert(completions, {
              label = text, -- El texto que se muestra en el menú
              insertText = text, -- El texto que se inserta en el buffer
              kind = cmp.lsp.CompletionItemKind.Text, -- El tipo de ítem
              source = "GPT-mini 5", -- El nombre de nuestra fuente
            })
          end
          -- Devolvemos las completiciones a nvim-cmp
          callback(completions)
        end
      end
    end,
    on_stderr = function(_, err)
      -- `err` es una tabla de strings. Notificar solo si hay un mensaje de error real.
      if err and err[1] and err[1] ~= "" then
        vim.notify("Error en la API de GPT-mini 5: " .. table.concat(err, " "), vim.log.levels.ERROR)
      end
    end,
  })
end

return M
