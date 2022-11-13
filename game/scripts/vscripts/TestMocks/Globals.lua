local CUtilities = require("Utilities")

local NewGlobalsMock = function ()
    local GlobalsMock = { CachedResources = {} }

    ---@param ResourceType string
    ---@param ResourcePath string
    ---@param PrecacheContext table
    function GlobalsMock.PrecacheResource(ResourceType, ResourcePath, PrecacheContext)
        GlobalsMock.CachedResources[ResourcePath] = GlobalsMock.CachedResources[ResourcePath] or {}
        GlobalsMock.CachedResources[ResourcePath].ResourceType = ResourceType
        GlobalsMock.CachedResources[ResourcePath].PrecacheContext = PrecacheContext
    end

    ---@param ResourcePath string
    ---@return boolean
    function GlobalsMock:_IsResourceCached(ResourcePath)
        return CUtilities.ToBoolean(self.CachedResources[ResourcePath])
    end

    ---@param ResourcePath string
    ---@return string
    function GlobalsMock:_GetResourceType(ResourcePath)
        return (self.CachedResources[ResourcePath] or { ResourceType = ""}).ResourceType
    end

    ---@param ResourcePath string
    ---@return table
    function GlobalsMock:_GetPrecacheContext(ResourcePath)
        return  (self.CachedResources[ResourcePath] or { PrecacheContext = nil }).PrecacheContext
    end

    return GlobalsMock
end

local NewCGlobalsMock = function ()
    CGlobalsMockMetaTable = CGlobalsMockMetaTable or {}

    function CGlobalsMockMetaTable:__call()
        return NewGlobalsMock()
    end
    
    return setmetatable({}, CGlobalsMockMetaTable)
end

return NewCGlobalsMock()