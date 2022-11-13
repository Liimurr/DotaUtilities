local NewEntitiesMock = function ()
    local EntitiesMock = { RegisteredEntities = {} }

    function EntitiesMock:FindByName(Name)
        local Result = self.RegisteredEntities[Name]
        return Result
    end
    
    ---@param EntityMock table
    function EntitiesMock:_AddEntity(EntityMock)
        self.RegisteredEntities[EntityMock.Name] = EntityMock
    end
    
    ---@param EntityMocks table[]
    function EntitiesMock:_AddEnties(EntityMocks)
        for _, EntityMock in pairs(EntityMocks) do
            self:_AddEntity(EntityMock)
        end
    end

    return EntitiesMock
end

local NewCEntitiesMock = function ()
    local CEntities = {}
    function CEntities:__call()
        return NewEntitiesMock()
    end
    return setmetatable(CEntities, CEntities)
end

return NewCEntitiesMock()