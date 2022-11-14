local CUtilities = require("Utilities")

local NewChannel = function ()
    ---@generic T
    ---@class Channel<T>
    local Channel = {
        CoroutineHandle = nil,
        bIsClosed = false
    }

    ChannelMetaTable = ChannelMetaTable or {}

    ---@generic T
    ---@return T | nil
    function ChannelMetaTable:__call()
        if not self.bIsClosed then
            local SplitCoroutineReturn = function (Head, ...) return Head, {...} end
            local status_, ReturnValues = SplitCoroutineReturn(coroutine.resume(self.CoroutineHandle))
            if not status_ then
                print("!!!!!!!!!!!!!!!!!!!!!!!!")
            end
            if coroutine.status(self.CoroutineHandle) == "dead" then
                self.bIsClosed = true
                return nil
            else
                return CUtilities.Unpack(ReturnValues)
            end
        end
    end

    ---@generic T
    ---@return T[]
    function Channel:Buffer()
        local Buffer = {}
        self:ConsumeEach(function (...) table.insert(Buffer, ...) end)
        return Buffer
    end

    ---@generic T
    ---@param Function fun(ProduceResult : T)?
    function Channel:Consume(Function)
        if not self.bIsClosed then
            local SplitCoroutineReturn = function (Head, ...) return Head, {...} end
            local _, ReturnValues = SplitCoroutineReturn(coroutine.resume(self.CoroutineHandle))
            if coroutine.status(self.CoroutineHandle) == "dead" then
                self.bIsClosed = true
            else
                if Function then
                    Function(CUtilities.Unpack(ReturnValues))
                end
            end
        end
    end

    ---@generic T
    ---@param Function fun(ProduceResult : T)?
    function Channel:ConsumeEach(Function)
        while not self.bIsClosed do
            self:Consume(Function)
        end
    end

    function Channel:Cancel()
        self.bIsClosed = true
    end

    return setmetatable(Channel, ChannelMetaTable)
end

---@generic T
---@param Funciton fun()
---@return Channel<T>
local Produce = function (Funciton)
    local Channel = NewChannel()
    Channel.CoroutineHandle = coroutine.create(Funciton)
    return Channel
end

return Produce