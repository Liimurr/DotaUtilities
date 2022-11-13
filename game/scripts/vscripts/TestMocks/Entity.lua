local CVector = require("TestMocks.Vector")

local NewEntityMock = function ()
    ---@class CEntity
    ---@field Name string
    ---@field Origin CVectorMock
    local EntityMock = {}

    function EntityMock:GetAbsOrigin()
        return self.Origin
    end

    function EntityMock:GetName()
        return self.Name
    end

    function EntityMock:_SetAbsOrigin(Vector)
        self.Origin = Vector
    end

    return EntityMock
end

local NewCEntityMock = function ()
    CEntityMockMetaTable = CEntityMockMetaTable or {}

    ---@param Name string
    ---@param Vector CVectorMock?
    ---@return CEntity
    function CEntityMockMetaTable:__call(Name, Vector)
        local Entity = NewEntityMock()
        Entity.Name = Name
        Entity.Origin = Vector or CVector(0,0,0)
        return Entity
    end

    return setmetatable({}, CEntityMockMetaTable)
end

return NewCEntityMock()