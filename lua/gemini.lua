    -- @file: lua/gemini.lua
    
    ---@module 'gemini.nvim'
    ---@param mission string
    ---@param args table
    function greet(name)
        print("Olá, " .. name .. "! O plugin gemini.nvim está carregado e pronto para uso.")
    end
    
    return {
        greet = greet
    }
    