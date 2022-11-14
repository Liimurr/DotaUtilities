local NewEntitiesMock = function ()
    local EntitiesMock = { RegisteredEntities = {} }

    ---comment
    ---@param PreviousEntity nil
    ---@param Name string
    ---@return Entity?
    function EntitiesMock:FindByName(PreviousEntity, Name)
        if (PreviousEntity) then error("PreviousEntity is currently not supported by this mock interface") end
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
    CEntitiesMetaTable = CEntitiesMetaTable or {}
    function CEntitiesMetaTable:__call()
        return NewEntitiesMock()
    end
    return setmetatable({}, CEntitiesMetaTable)
end

return NewCEntitiesMock()