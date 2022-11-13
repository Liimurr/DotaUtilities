local Produce = require("Produce")

---@param Table table
---@return Channel
return function (Table)
    return Produce(function ()
        for _, V in pairs(Table) do
            coroutine.yield(V)
        end
    end)
end