local CUtilities = {}

CUtilities.Pack = table.pack or function (...) return {...} end

CUtilities.Unpack = table.unpack or unpack

-- Very rarely needed. Use if trying to coerce a value to a boolean from another value type (For example coercing an optional table to a boolean before returning)
---@param Value any
---@return boolean
CUtilities.ToBoolean = function (Value) return not not Value end

---@param A number
---@param B number
---@param Epsilon number?
CUtilities.IsNearlyEqual = function (A, B, Epsilon)
    Epsilon = Epsilon or 0.01
    return math.abs(A - B) < Epsilon
end

return CUtilities