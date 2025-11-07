return {
  'tzachar/cmp-ai',
  dependencies = 'nvim-lua/plenary.nvim',
  config = function()
    local cmp_ai = require('cmp_ai.config')
    cmp_ai:setup({
      provider = 'OpenAI',
      provider_options = {
        model = 'gpt-4o-mini',  -- Cambiado a gpt-4o-mini
      },
      run_on_every_keystroke = true,
      notify = true,
      notify_callback = function(msg) vim.notify(msg) end,
    })
  end
}
