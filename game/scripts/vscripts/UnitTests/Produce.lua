local CTestSuite = require("TestSuite")
local Produce = require("Produce")
local CUtilities = require("Utilities")
local ProduceTestSuite = CTestSuite("ProduceTestSuite")

function ProduceTestSuite:Test_Call()
    local i = 1
    local NumberProducer = Produce(function ()
        while(true) do
            coroutine.yield(i)
            i = i+1
        end
    end)
    self:AssertEqual(NumberProducer(),  1)
    self:AssertEqual(NumberProducer(),  2)
    self:AssertEqual(NumberProducer(),  3)
    self:AssertEqual(NumberProducer(),  4)
end

function ProduceTestSuite:Test_Cancel()
    local i = 1
    local NumberProducer = Produce(function ()
        while(true) do
            coroutine.yield(i)
            i = i+1
        end
    end)
    self:AssertEqual(NumberProducer(),  1)
    self:AssertEqual(NumberProducer(),  2)
    NumberProducer:Cancel()
    self:AssertEqual(NumberProducer(),  nil)
    self:AssertEqual(NumberProducer(),  nil)
end

function ProduceTestSuite:Test_Buffer()
    local NumberProducer = Produce(function ()
        for i=1, 4 do
            coroutine.yield(i*i)
        end
    end)
    local Buffer = NumberProducer:Buffer()
    self:AssertEqual(Buffer[1],  1)
    self:AssertEqual(Buffer[2],  4)
    self:AssertEqual(Buffer[3],  9)
    self:AssertEqual(Buffer[4],  16)
    self:AssertEqual(Buffer[5],  nil)
end

function ProduceTestSuite:Test_Consume()
    local NumberProducer = Produce(function ()
        for i=1, 4 do
            coroutine.yield(i*i)
        end
    end)
    local TestConsumeNext = function (ExpectedNumber)
        local Result = nil
        NumberProducer:Consume(function (Number) Result=Number end)
        self:AssertEqual(ExpectedNumber, Result)
    end
    TestConsumeNext(1)
    TestConsumeNext(4)
    TestConsumeNext(9)
    TestConsumeNext(16)
    local bWasCalled = false
    NumberProducer:Consume(function () bWasCalled=true end)
    self:AssertEqual(false, bWasCalled)
end

function ProduceTestSuite:Test_ConsumeEach()
    local NumberProducer = Produce(function ()
        for i=1, 4 do
            coroutine.yield(i*i)
        end
    end)
    local Buffer = {}
    NumberProducer:ConsumeEach(function (Number) table.insert(Buffer, Number) end)
    self:AssertEqual(#Buffer, 4)
    self:AssertEqual(Buffer[1], 1)
    self:AssertEqual(Buffer[2], 4)
    self:AssertEqual(Buffer[3], 9)
    self:AssertEqual(Buffer[4], 16)
end

return ProduceTestSuite