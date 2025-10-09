local M = {}

function M.generate_and_display_graph(command)
  vim.fn.system(command, function(_, output)
    if (output == nil) or (output == '') then
      print("Error: El comando no generó ninguna salida. Asegúrate de que las herramientas (ej. graph-easy) estén instaladas y en tu PATH.")
      return
    end

    -- Abrir una nueva ventana vertical
    vim.cmd('vnew')
    -- Entrar en modo inserción para el nuevo buffer
    vim.cmd('startinsert')
    -- Establecer el tipo de archivo para que no tenga formato específico
    vim.bo.filetype = 'text'
    vim.bo.buftype = 'nofile'
    vim.bo.bufhidden = 'wipe'
    vim.bo.swapfile = false

    -- Dividir la salida en líneas y pegarla en el buffer
    local lines = {}
    for s in output:gmatch("[^\r\n]+") do
      table.insert(lines, s)
    end
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    -- Volver al modo normal
    vim.cmd('stopinsert')
  end)
end

-- Comando de ejemplo para Python. El usuario deberá adaptarlo.
-- Uso: :GenGraphPy <ruta_al_script.py>
vim.api.nvim_create_user_command(
  'GenGraphPy',
  function(opts)
    if not opts.args or opts.args == '' then
      print("Uso: :GenGraphPy <ruta_al_script.py>")
      return
    end
    -- Comando que usa pycallgraph2 y graph-easy
    local cmd = "pycallgraph2 graphviz -- " .. opts.args .. " | graph-easy --as_ascii"
    M.generate_and_display_graph(cmd)
  end,
  { nargs = 1, complete = "file" }
)

-- Comando genérico. Uso: :GenGraph "tu_comando_aqui"
vim.api.nvim_create_user_command(
  'GenGraph',
  function(opts)
    if not opts.args or opts.args == '' then
      print('Uso: :GenGraph "comando | graph-easy --as_ascii"')
      return
    end
    M.generate_and_display_graph(opts.args)
  end,
  { nargs = 1 }
)

-- Comando para Java. Uso: :GenGraphJava <ruta_al_jar>
vim.api.nvim_create_user_command(
  'GenGraphJava',
  function(opts)
    if not opts.args or opts.args == '' then
      print("Uso: :GenGraphJava <ruta_al_fichero.jar>")
      return
    end
    -- La ruta al jcallgraph.jar que descargamos
    local jcallgraph_path = vim.fn.stdpath("config") .. "/tools/jcallgraph-2.0.jar"
    -- Comando que usa jcallgraph y graph-easy. Se ejecuta en un directorio temporal para no dejar basura.
    local cmd = string.format(
      "cd $(mktemp -d) && java -jar %s %s && cat jcallgraph.dot | graph-easy --as_ascii",
      jcallgraph_path,
      opts.args
    )
    M.generate_and_display_graph(cmd)
  end,
  { nargs = 1, complete = "file" }
)


return M
