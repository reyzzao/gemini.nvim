-- @file: lua/gemini.lua

local M = {}

--- @mission: Configura o plugin gemini.nvim, criando o comando de usuário para interagir com o Gemini.
--- @args: {opts: table} Tabela opcional com configurações do plugin, como a API Key.
--- @description: Este é o ponto de entrada principal do plugin, garantindo que o comando seja criado apenas uma vez.
function M.setup(opts)
  -- A função é chamada pelo LazyVim, garantindo que o comando seja criado.
  -- print("gemini.nvim: Setup concluído.")

  -- Cria o comando de usuário :Gemini
  vim.api.nvim_create_user_command(
    "Gemini",
    function(data)
      -- Ação a ser executada quando o comando :Gemini for chamado
      local name = data.args or "Rzj"
      M.greet(name)
    end,
    {
      nargs = "?", -- O comando pode receber argumentos
      desc = "Exibe uma mensagem de boas-vindas do plugin Gemini"
    }
  )
end

--- @mission: Exibe uma mensagem de boas-vindas na linha de comando do Neovim.
--- @args: {name: string} O nome do usuário a ser saudado.
--- @return: void
function M.greet(name)
  print("Olá, " .. name .. "! O plugin gemini.nvim está carregado e pronto para uso.")
end

-- Retorna a tabela M como o módulo do plugin.
-- Esta é a parte crítica para que o LazyVim possa encontrar a função `setup()`.
return M
