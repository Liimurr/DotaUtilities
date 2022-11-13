local CTestSuite = require("TestSuite")
local ProduceExtensionsTestSuite = CTestSuite("ProduceExtensionsTestSuite")

function ProduceExtensionsTestSuite:Test_ProduceValues()
    -- produce array values
    local ProduceValues = require("ProduceExtensions.ProduceValues")
    local Array = { 'a', 'b', 'c'}
    local ProduceArrayValues = ProduceValues(Array)
    local i = 1
    for Value in ProduceArrayValues do
        self:AssertEqual(Value, Array[i])
        i = i+1
    end

    -- produce table values
    local Table = { KeyA='a', KeyB='b', KeyC='c' }
    local Set = {}
    local ProduceTableValues = ProduceValues(Table)
    local NumProduced = 0
    for Value in ProduceTableValues do
        Set[Value] = true
        NumProduced = NumProduced+1
    end
    self:AssertEqual(NumProduced, 3)
    self:AssertEqual(Set['a'], true)
    self:AssertEqual(Set['b'], true)
    self:AssertEqual(Set['c'], true)
end

function ProduceExtensionsTestSuite:Test_Iota()
    local Iota = require("ProduceExtensions.Iota")
    local ProduceNumbers = Iota(10, 15)
    local Buffer = {}
    for Number in ProduceNumbers do
        table.insert(Buffer, Number)
    end
    self:AssertEqual(#Buffer, 6)
    self:AssertEqual(Buffer[1], 10)
    self:AssertEqual(Buffer[2], 11)
    self:AssertEqual(Buffer[3], 12)
    self:AssertEqual(Buffer[4], 13)
    self:AssertEqual(Buffer[5], 14)
    self:AssertEqual(Buffer[6], 15)
    self:AssertEqual(Buffer[7], nil)
end

return ProduceExtensionsTestSuite