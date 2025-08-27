-- @file: lua/gemini.lua

local M = {}
local api_key = ""
local api_endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key="

--- @mission: Configura o plugin gemini.nvim, definindo a API key e os comandos de usuário.
--- @args: {opts: table} Tabela de configuração. Espera o campo 'api_key'.
--- @description: Este é o ponto de entrada principal do plugin, define a API key e os comandos de usuário.
function M.setup(opts)
  if opts and opts.api_key and opts.api_key ~= "" then
    api_key = opts.api_key
  else
    print("gemini.nvim: Aviso! A API Key não foi fornecida na configuração.")
  end

  vim.api.nvim_create_user_command(
    "Gemini",
    function()
      M.send_visual_selection()
    end,
    {
      range = true,
      desc = "Envia a seleção visual para o Gemini e insere a resposta."
    }
  )

  vim.api.nvim_create_user_command(
    "GeminiPrompt",
    function()
      M.send_prompt()
    end,
    {
      desc = "Abre uma caixa de prompt para enviar uma pergunta ao Gemini."
    }
  )
end

--- @mission: Envia o texto da seleção visual para a API do Gemini.
--- @args: void
--- @description: Obtém o texto selecionado em modo visual, prepara e envia para a API.
function M.send_visual_selection()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  local text = table.concat(vim.fn.getline(start_line, end_line), "\n")
  
  if text == "" then
    print("gemini.nvim: Por favor, selecione algum texto no modo visual.")
    return
  end

  M.send_text_to_gemini(text)
end

--- @mission: Abre uma caixa de prompt e envia o texto para a API do Gemini.
--- @args: void
--- @description: Abre um prompt, captura a entrada do usuário e a envia para a API do Gemini.
function M.send_prompt()
  vim.ui.input({ prompt = "Gemini: " }, function(input)
    if input and input ~= "" then
      M.send_text_to_gemini(input)
    else
      print("gemini.nvim: Operação cancelada ou texto vazio.")
    end
  end)
end

--- @mission: Envia uma string de texto para a API do Gemini e insere a resposta.
--- @args: {text: string} A string de texto a ser enviada.
--- @description: Esta é a função central que faz a chamada para a API e lida com a resposta.
function M.send_text_to_gemini(text)
  if not api_key or api_key == "" then
    print("gemini.nvim: Erro! A API Key não está configurada.")
    return
  end

  local payload = {
    contents = {
      {
        parts = {
          { text = text }
        }
      }
    }
  }

  local json_payload = vim.fn.json_encode(payload)

  print("gemini.nvim: Enviando texto para o Gemini...")

  local curl_command = string.format(
    "curl -s -X POST -H 'Content-Type: application/json' --data-binary '%s' '%s%s'",
    json_payload,
    api_endpoint,
    api_key
  )

  local response_json = vim.fn.system(curl_command)
  local response_data = vim.fn.json_decode(response_json)

  if response_data and response_data.candidates and response_data.candidates[1] and
     response_data.candidates[1].content and response_data.candidates[1].content.parts and
     response_data.candidates[1].content.parts[1] and response_data.candidates[1].content.parts[1].text then

    local generated_text = response_data.candidates[1].content.parts[1].text
    
    print("gemini.nvim: Resposta recebida! Inserindo...")

    vim.defer_fn(function()
      vim.api.nvim_put({ generated_text }, "", true, true)
    end, 100)
    
  else
    print("gemini.nvim: Erro ao obter resposta. Verifique sua API Key ou a conexão.")
    print("Resposta completa (debug):")
    print(response_json)
  end
end

return M
