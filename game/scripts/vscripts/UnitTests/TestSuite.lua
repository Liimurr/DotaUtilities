local CTestSuite = require("TestSuite")

local ExampleTestSuite = CTestSuite("ExampleTestSuite")

function ExampleTestSuite:ContinueOnError()
    return true
end

function ExampleTestSuite:Test_1()
    self:AssertEqual("a", "a")
    self:AssertEqual("b", "b")

    -- this will fail this child test
    -- self:AssertEqual("b", "c")
end

function ExampleTestSuite:Test_2()
    self:AssertEqual("d", "d")

    -- this will fail this child test
    -- self:AssertNotEqual("e", "e")
end

function ExampleTestSuite:Test_3()
    self:AssertEqual("f", "f")

    -- this will fail this child test
    -- self:AssertNotEqual("g", "g")
end

return ExampleTestSuite
