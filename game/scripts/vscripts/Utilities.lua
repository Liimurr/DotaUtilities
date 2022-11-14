local CUtilities = {}

CUtilities.Pack = table.pack or function (...) return {...} end

CUtilities.Unpack = table.unpack or unpack

---@param Value any
---@return boolean
CUtilities.ToBoolean = function (Value) return not not Value end

---@param A number
---@param B number
---@param Epsilon number?
CUtilities.IsNearlyEqual = function (A, B, Epsilon)
    Epsilon = Epsilon or 0.001
    return math.abs(A - B) < Epsilon
end

---@param Arg any
---@param FunctionName string
---@param ArgNumber integer
---@return boolean
CUtilities.ExpectNonNilArgument = function(Arg, FunctionName, ArgNumber) 
    if not Arg then
        print("WARNING: Expected non nil argument to "..FunctionName.." at arg position "..tostring(ArgNumber))
        return false
    end
    return true
end

---@param Arg any[]
---@param FunctionName string
---@param ArraySize integer
---@param ArgNumber integer
---@return boolean
CUtilities.ExpectArrayOfSizeGreaterThanOrEqualTo = function (Arg, FunctionName, ArraySize, ArgNumber)
    if not Arg or #Arg < ArraySize then
        print("WARNING: Expected non nil array argument of size greater than or equal to "..ArraySize.." passed to "..FunctionName.." at arg position "..tostring(ArgNumber))
        return false
    end
    return true
end

return CUtilities