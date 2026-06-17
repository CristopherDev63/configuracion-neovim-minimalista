-- ============================================================================
-- lag-monitor.lua — Diagnosticador de Input Lag en Tiempo Real
-- Mide, registra y muestra QUÉ está bloqueando el Main Thread mientras programas
-- ============================================================================

local M = {}

-- ============================================================================
-- CONFIG
-- ============================================================================
local config = {
  profiling_enabled = false,
  floating_win = false,
  log_to_messages = false,
}

-- ============================================================================
-- TIMING ENGINE
-- ============================================================================
local start_time = vim.uv.now
local timers = {}
local slow_ops = {}   -- ops acumuladas para top 5
local recent_lags = {} -- últimos 20 eventos de lag mayor a 16ms
local op_counter = 0

-- Hook storage
local hooks = {
  TextChangedI = nil,
  CursorMovedI = nil,
  CursorHold = nil,
  vim_schedule = nil,
}

-- ============================================================================
-- PROFILE WRAPPER — Mide tiempo de ejecución de cualquier función
-- ============================================================================
function M.profile(label, fn, ...)
  local t0 = start_time()
  local ok, result = pcall(fn, ...)
  local elapsed = start_time() - t0

  if elapsed > 1 then
    op_counter = op_counter + 1
    local entry = {
      id = op_counter,
      label = label,
      elapsed = elapsed,
      time = os.date("%H:%M:%S"),
    }

    -- Acumular en slow_ops
    slow_ops[#slow_ops + 1] = entry
    table.sort(slow_ops, function(a, b) return a.elapsed > b.elapsed end)
    if #slow_ops > 10 then slow_ops[#slow_ops] = nil end

    -- Registrar si es lag (>16ms = 1 frame a 60fps)
    if elapsed > 16 then
      recent_lags[#recent_lags + 1] = entry
      if #recent_lags > 30 then
        table.remove(recent_lags, 1)
      end
      if config.log_to_messages then
        vim.notify(string.format("[LAG] %s: %dms", label, elapsed), vim.log.levels.WARN)
      end
    end
  end

  if not ok then
    vim.notify("[profile] " .. label .. ": " .. tostring(result), vim.log.levels.ERROR)
  end

  return result
end

-- ============================================================================
-- BENCINARQUÍA DE EVENTOS — Hookea autocmds clave
-- ============================================================================
local function install_hooks()
  if hooks.installed then return end
  hooks.installed = true

  local augroup = vim.api.nvim_create_augroup("LagMonitorHooks", { clear = true })

  -- TextChangedI: cada tecla en insert mode
  vim.api.nvim_create_autocmd("TextChangedI", {
    group = augroup,
    callback = function()
      M.mark("TextChangedI")
    end,
  })

  -- CursorMovedI: cada movimiento de cursor
  vim.api.nvim_create_autocmd("CursorMovedI", {
    group = augroup,
    callback = function()
      M.mark("CursorMovedI")
    end,
  })

  -- CursorMoved: en normal mode
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = augroup,
    callback = function()
      M.mark("CursorMoved")
    end,
  })

  -- InsertCharPre: antes de insertar un carácter
  vim.api.nvim_create_autocmd("InsertCharPre", {
    group = augroup,
    callback = function()
      M.mark("InsertCharPre")
    end,
  })

  -- WinScrolled: cuando se redibuja la ventana
  vim.api.nvim_create_autocmd("WinScrolled", {
    group = augroup,
    callback = function()
      M.mark("WinScrolled")
    end,
  })
end

-- ============================================================================
-- MONITOR DE EVENTOS EN VIVO
-- ============================================================================
local event_deltas = {}
local last_event_time = {}
local event_total_time = {}

function M.mark(event_name)
  if not config.profiling_enabled then return end
  local now = start_time()
  local last = last_event_time[event_name] or now
  local delta = now - last
  last_event_time[event_name] = now

  -- Acumular tiempo total
  event_total_time[event_name] = (event_total_time[event_name] or 0) + delta

  -- Guardar delta en el ring buffer
  if not event_deltas[event_name] then
    event_deltas[event_name] = {}
  end
  local buf = event_deltas[event_name]
  buf[#buf + 1] = delta
  if #buf > 60 then
    table.remove(buf, 1)
  end
end

-- ============================================================================
-- HOOKEAR vim.schedule y vim.defer_fn para medir backlog
-- ============================================================================
local scheduled_count = 0
local defer_fn_count = 0
local max_backlog = 0

local original_schedule = vim.schedule
vim.schedule = function(fn, ...)
  scheduled_count = scheduled_count + 1
  original_schedule(function(...)
    local t0 = start_time()
    fn(...)
    local elapsed = start_time() - t0
    if elapsed > 16 then
      vim.notify(string.format("[SCHEDULE] %dms en callback #%d", elapsed, scheduled_count), vim.log.levels.WARN)
    end
  end, ...)
end

local original_defer_fn = vim.defer_fn
vim.defer_fn = function(fn, delay)
  defer_fn_count = defer_fn_count + 1
  if delay > 50 then
    max_backlog = math.max(max_backlog, delay)
  end
  return original_defer_fn(function()
    local t0 = start_time()
    fn()
    local elapsed = start_time() - t0
    if elapsed > 16 then
      vim.notify(string.format("[DEFER] %dms en callback #%d (delay=%dms)", elapsed, defer_fn_count, delay), vim.log.levels.WARN)
    end
  end, delay)
end

-- ============================================================================
-- TEST DE LATENCIA — Mide cuánto tarda una tecla en procesarse
-- ============================================================================
local latency_test_active = false
local latency_samples = {}
local last_textchanged_time = 0

function M.start_latency_test()
  latency_test_active = true
  latency_samples = {}
  vim.notify("[LagMonitor] Test de latencia iniciado. Escribe normalmente por 5 segundos...", vim.log.levels.INFO)

  vim.defer_fn(function()
    M.stop_latency_test()
  end, 5000)
end

function M.stop_latency_test()
  latency_test_active = false
  if #latency_samples == 0 then
    vim.notify("[LagMonitor] No se registraron muestras.", vim.log.levels.INFO)
    return
  end

  local sum = 0
  local max = 0
  local min = 999
  for _, ms in ipairs(latency_samples) do
    sum = sum + ms
    if ms > max then max = ms end
    if ms < min then min = ms end
  end
  local avg = sum / #latency_samples

  -- Contar cuántos superan 16ms, 33ms, 50ms, 100ms
  local over_16, over_33, over_50, over_100 = 0, 0, 0, 0
  for _, ms in ipairs(latency_samples) do
    if ms > 16 then over_16 = over_16 + 1 end
    if ms > 33 then over_33 = over_33 + 1 end
    if ms > 50 then over_50 = over_50 + 1 end
    if ms > 100 then over_100 = over_100 + 1 end
  end

  vim.notify("", vim.log.levels.INFO)
  vim.notify("═══════════════════════════════════════════", vim.log.levels.INFO)
  vim.notify("  RESULTADOS TEST DE LATENCIA", vim.log.levels.INFO)
  vim.notify("  Muestras: " .. #latency_samples, vim.log.levels.INFO)
  vim.notify(string.format("  Mín: %dms  |  Máx: %dms  |  Promedio: %.1fms", min, max, avg), vim.log.levels.INFO)
  vim.notify("", vim.log.levels.INFO)
  vim.notify("  ◉  >16ms (1 frame):   " .. over_16 .. " veces", vim.log.levels.INFO)
  vim.notify("  ◉  >33ms (2 frames):  " .. over_33 .. " veces", vim.log.levels.INFO)
  vim.notify("  ◉  >50ms (3 frames):  " .. over_50 .. " veces", vim.log.levels.INFO)
  vim.notify("  ◉  >100ms (lag not.): " .. over_100 .. " veces", vim.log.levels.INFO)
  vim.notify("", vim.log.levels.INFO)
  vim.notify("  ▶ INPUT LAG es perceptible >33ms", vim.log.levels.INFO)
  vim.notify("  ▶ INPUT LAG es molesto >50ms", vim.log.levels.INFO)
  vim.notify("  ▶ INPUT LAG es inusable >100ms", vim.log.levels.INFO)
  vim.notify("═══════════════════════════════════════════", vim.log.levels.INFO)
end

-- Hook para medir latencia real de tecla
vim.api.nvim_create_autocmd("InsertCharPre", {
  callback = function()
    if not latency_test_active then return end
    local now = vim.uv.now()
    if last_textchanged_time > 0 then
      local delta = now - last_textchanged_time
      latency_samples[#latency_samples + 1] = delta
    end
    last_textchanged_time = now
  end,
})

-- ============================================================================
-- OPERACIONES MÁS LENTAS (TOP 10)
-- ============================================================================
function M.get_slow_ops(count)
  count = count or 10
  local result = {}
  for i = 1, math.min(count, #slow_ops) do
    result[i] = slow_ops[i]
  end
  return result
end

-- ============================================================================
-- ESTADO DEL SISTEMA EN VIVO
-- ============================================================================
function M.get_status()
  local now = vim.uv.now()

  -- Calcular frecuencia de eventos recientes
  local event_freq = {}
  for name, buf in pairs(event_deltas) do
    local sum = 0
    for _, d in ipairs(buf) do
      sum = sum + d
    end
    local avg_ms = #buf > 0 and (sum / #buf) or 0
    local freq_hz = avg_ms > 0 and math.floor(1000 / avg_ms) or 0
    event_freq[name] = {
      avg_ms = math.floor(avg_ms * 100) / 100,
      freq_hz = freq_hz,
      samples = #buf,
    }
  end

  return {
    uptime = now - (start_time()),
    scheduled_calls = scheduled_count,
    defer_calls = defer_fn_count,
    max_defer_backlog = max_backlog,
    top5 = M.get_slow_ops(5),
    recent_lags = recent_lags,
    event_freq = event_freq,
    profiling = config.profiling_enabled,
    last_lag_count = #recent_lags,
    last_lag_time = #recent_lags > 0 and recent_lags[#recent_lags].time or nil,
  }
end

-- ============================================================================
-- VENTANA FLOTANTE DE MONITOREO EN VIVO
-- ============================================================================
local float_win = nil
local float_buf = nil
local float_timer = nil

function M.toggle_floating()
  if float_win and vim.api.nvim_win_is_valid(float_win) then
    vim.api.nvim_win_close(float_win, true)
    float_win = nil
    float_buf = nil
    if float_timer then
      float_timer:close()
      float_timer = nil
    end
    return
  end

  float_buf = vim.api.nvim_create_buf(false, true)
  local width = 56
  local height = 22
  local ui = vim.api.nvim_list_uis()[1]
  local row = ui and math.floor(ui.height / 2 - height / 2) or 10
  local col = ui and ui.width - width - 2 or 80

  float_win = vim.api.nvim_open_win(float_buf, false, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "single",
    title = " Lag Monitor ",
    title_pos = "center",
  })

  vim.api.nvim_win_set_option(float_win, "winhl", "Normal:NormalFloat,FloatBorder:FloatBorder")

  -- Timer de refresco (cada 500ms)
  float_timer = vim.uv.new_timer()
  float_timer:start(0, 500, vim.schedule_wrap(function()
    M.update_floating()
  end))
end

function M.update_floating()
  if not float_buf or not vim.api.nvim_buf_is_valid(float_buf) then
    if float_timer then
      float_timer:close()
      float_timer = nil
    end
    return
  end

  local status = M.get_status()
  local lines = {}

  lines[#lines + 1] = "  Top 5 operaciones más lentas:"
  if #status.top5 == 0 then
    lines[#lines + 1] = "    (aún no hay datos — empieza a escribir)"
  else
    for i, op in ipairs(status.top5) do
      local icon = op.elapsed > 100 and "🔴" or (op.elapsed > 50 and "🟡" or (op.elapsed > 33 and "🟠" or "⚪"))
      lines[#lines + 1] = string.format("  %s %2d. %-28s %3dms",
        icon, i, op.label:sub(1, 28), op.elapsed)
    end
  end

  lines[#lines + 1] = ""
  lines[#lines + 1] = "  Frecuencia de eventos (promedio):"
  if next(status.event_freq) then
    -- Ordenar por freq descendente
    local sorted = {}
    for name, data in pairs(status.event_freq) do
      sorted[#sorted + 1] = { name = name, data = data }
    end
    table.sort(sorted, function(a, b) return a.data.freq_hz > b.data.freq_hz end)
    for i = 1, math.min(5, #sorted) do
      local s = sorted[i]
      lines[#lines + 1] = string.format("    %-16s %3d Hz  (c/%dms)",
        s.name, s.data.freq_hz, s.data.avg_ms)
    end
  else
    lines[#lines + 1] = "    (sin datos aún)"
  end

  lines[#lines + 1] = ""
  lines[#lines + 1] = string.format("  vim.schedule: %d  |  vim.defer_fn: %d", status.scheduled_calls, status.defer_calls)
  lines[#lines + 1] = string.format("  Perfilando: %s  |  Lags >16ms: %d",
    status.profiling and "✓" or "✗", #status.recent_lags)

  if #status.recent_lags > 0 then
    local last = status.recent_lags[#status.recent_lags]
    lines[#lines + 1] = string.format("  Último lag: %s a las %s (%dms)",
      last.label:sub(1, 20), last.time, last.elapsed)
  end

  vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, lines)
end

-- ============================================================================
-- COMANDOS
-- ============================================================================

-- Toggle perfilado
function M.toggle_profiling()
  config.profiling_enabled = not config.profiling_enabled
  if config.profiling_enabled then
    install_hooks()
    vim.notify("[LagMonitor] Perfilado ACTIVADO — se miden todas las operaciones", vim.log.levels.INFO)
  else
    vim.notify("[LagMonitor] Perfilado DESACTIVADO", vim.log.levels.INFO)
  end
end

-- Toggle log automático
function M.toggle_logging()
  config.log_to_messages = not config.log_to_messages
  vim.notify("[LagMonitor] Log automático: " .. (config.log_to_messages and "✓" or "✗"), vim.log.levels.INFO)
end

-- Mostrar top 10 lento
function M.show_slow_ops()
  local top = M.get_slow_ops(10)
  if #top == 0 then
    vim.notify("[LagMonitor] No hay operaciones lentas registradas. Activa profiling con :LagProfile", vim.log.levels.INFO)
    return
  end
  vim.notify("═══════════════════ TOP 10 LENTOS ═══════════════════", vim.log.levels.INFO)
  for i, op in ipairs(top) do
    vim.notify(string.format("  %2d. %-35s %3dms  (%s)", i, op.label, op.elapsed, op.time), vim.log.levels.INFO)
  end
  vim.notify("══════════════════════════════════════════════════════", vim.log.levels.INFO)
end

-- Test de latencia rápido
function M.run_latency_test()
  M.start_latency_test()
end

-- Kill switch para plugins individuales
function M.kill(what)
  what = what or "all"
  if what == "illuminate" or what == "all" then
    pcall(require("illuminate").destroy)
    vim.notify("[LagMonitor] illuminate DESTRUIDO", vim.log.levels.INFO)
  end
  if what == "indentblankline" or what == "all" then
    pcall(require("ibl").setup, { indent = { char = "│" }, scope = { enabled = false } })
    vim.notify("[LagMonitor] indent-blankline scope DESACTIVADO", vim.log.levels.INFO)
  end
  if what == "blink" or what == "all" then
    -- Solo desactivar blink temporalmente
    vim.g.blink_cmp_disable = true
    vim.notify("[LagMonitor] blink.cmp DESACTIVADO (recarga con :Lazy reload blink.cmp)", vim.log.levels.INFO)
  end
  if what == "colorizer" or what == "all" then
    pcall(require("colorizer").toggle)
    vim.notify("[LagMonitor] colorizer TOGGLE", vim.log.levels.INFO)
  end
  if what == "lualine" or what == "all" then
    vim.opt.laststatus = 0
    vim.notify("[LagMonitor] lualine OCULTO (statusline off)", vim.log.levels.INFO)
  end
  if what == "treesitter" or what == "all" then
    pcall(vim.treesitter.stop, 0)
    vim.notify("[LagMonitor] treesitter DETENIDO en buffer actual", vim.log.levels.INFO)
  end
end

-- Restaurar todo
function M.restore()
  vim.notify("[LagMonitor] Para restaurar: cierra y abre Neovim otra vez, o recarga con :Lazy reload", vim.log.levels.INFO)
end

-- ============================================================================
-- REGISTRAR COMANDOS
-- ============================================================================

vim.api.nvim_create_user_command("LagMonitor", function(opts)
  local args = opts.args
  if args == "" or args == "toggle" then
    M.toggle_floating()
  elseif args == "profile" then
    M.toggle_profiling()
  elseif args == "log" then
    M.toggle_logging()
  elseif args == "top" then
    M.show_slow_ops()
  elseif args == "test" then
    M.run_latency_test()
  elseif args:match("^kill ") then
    M.kill(args:match("^kill (.+)$"))
  elseif args == "kill" then
    M.kill("all")
  elseif args == "restore" then
    M.restore()
  else
    vim.notify([[Comandos:
  :LagMonitor           — toggle ventana flotante
  :LagMonitor profile   — toggle perfilado
  :LagMonitor log       — toggle log automático
  :LagMonitor top       — mostrar top 10 más lentos
  :LagMonitor test      — test de latencia (5s)
  :LagMonitor kill      — matar plugins sospechosos
  :LagMonitor kill illuminate — matar solo illuminate
  :LagMonitor restore   — info de restauración]], vim.log.levels.INFO)
  end
end, {
  nargs = "?",
  complete = function()
    return { "toggle", "profile", "log", "top", "test", "kill", "restore" }
  end,
})

-- Keymaps
vim.keymap.set("n", "<leader>Lm", "<cmd>LagMonitor toggle<CR>", { desc = "Toggle Lag Monitor" })
vim.keymap.set("n", "<leader>Lp", "<cmd>LagMonitor profile<CR>", { desc = "Toggle Profiling" })
vim.keymap.set("n", "<leader>Lk", "<cmd>LagMonitor kill<CR>", { desc = "Kill all plugins sospechosos" })
vim.keymap.set("n", "<leader>Lt", "<cmd>LagMonitor test<CR>", { desc = "Test de latencia" })

return M
