local Produce = require("Produce")

---@param Start number
---@param End number
---@return Channel
return function (Start, End)
    return Produce(function ()
        for i=Start,End do
            coroutine.yield(i)
        end
    end)
end