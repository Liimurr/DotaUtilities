local NewPrecacheContextMock = function ()
    PrecacheContextMetaTable = PrecacheContextMetaTable or {}

    function PrecacheContextMetaTable:__tostring()
        return "MockPrecacheContext:"..string.format("%p", self)
    end

    return setmetatable({}, PrecacheContextMetaTable)
end

local NewCPrecacheContextMock = function ()
    CPrecacheContextMock = CPrecacheContextMock or {}

    function CPrecacheContextMock:__call()
        return NewPrecacheContextMock()
    end

    return setmetatable({}, CPrecacheContextMock)
end

return NewCPrecacheContextMock()