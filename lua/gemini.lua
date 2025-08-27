-- @file: lua/gemini.lua
local M = {}

---@mission Configura o plugin com as opções fornecidas pelo usuário.
---@param opts Config Opções de configuração para a API do Gemini.
function M.setup(opts)
  M.config = opts
end

---
---@mission Envia uma requisição para a API do Gemini com o conteúdo do buffer e a consulta do usuário.
---@param query string A consulta ou comando a ser enviado para o modelo.
---@return table A resposta da API, incluindo o texto gerado e metadados.
function M.prompt(query)
  local buffer_content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local prompt_text = table.concat(buffer_content, "\n") .. "\n\n" .. query

  -- TODO: Implementar a lógica de requisição real aqui
  -- Este é um exemplo hipotético do que a sua função de prompt faria:
  local payload = {
    contents = {
      parts = {
        {
          text = prompt_text
        }
      }
    },
    -- Use um nome de modelo correto e suportado pela API
    model = "gemini-1.5-flash-latest" -- #editable Altere o nome do modelo aqui
  }

  -- ... (sua lógica de requisição HTTP)
  -- local response = vim.fn.http_request(M.API_BASE_URL, { ... })
  -- return response
end

return M
