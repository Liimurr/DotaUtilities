local CUtilities = require("Utilities")

local NewVectorMock = function ()
    ---@class CVectorMock
    ---@field X number
    ---@field Y number
    ---@field Z number
    local VectorMock = {
        X = 0,
        Y = 0,
        Z = 0
    }

    VectorMockMetaTable = VectorMockMetaTable or {}

    ---@return string
    function VectorMockMetaTable:__tostring()
        return string.format("%s,%s,%s", self.X, self.Y, self.Z)
    end
    
    ---@param Other CVectorMock
    ---@return boolean
    function VectorMockMetaTable:__eq(Other)
        return CUtilities.IsNearlyEqual(self.X, Other.X) and CUtilities.IsNearlyEqual(self.Y, Other.Y) and CUtilities.IsNearlyEqual(self.Z, Other.Z)
    end

    return setmetatable(VectorMock, VectorMockMetaTable)
end

local NewCVectorMock = function ()
    CVectorMockMetaTable = CVectorMockMetaTable or {}

    ---@param X number
    ---@param Y number
    ---@param Z number
    ---@return CVectorMock
    function CVectorMockMetaTable:__call(X, Y, Z)
        local VectorMock = NewVectorMock()
        VectorMock.X = X
        VectorMock.Y = Y
        VectorMock.Z = Z
        return VectorMock
    end

    return setmetatable({}, CVectorMockMetaTable)
end

return NewCVectorMock()
