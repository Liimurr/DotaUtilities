local CTestSuite = require("TestSuite")
local ExperimentsSuite = CTestSuite("ExperimentsSuite")

function ExperimentsSuite:Test_Modulo()
    self:AssertEqual(12 % 10, 2)
end

function ExperimentsSuite:Test_OverWriteCall()
    local BaseCallCount = 0
    local ChildCallCount = 0
    local BaseObject = {}

    BaseObject.__call = function (Self)
        BaseCallCount = BaseCallCount + 1
    end
    setmetatable(BaseObject, BaseObject)
    BaseObject()
    self:AssertEqual(BaseCallCount, 1)
    
    local BaseObject__call = BaseObject.__call
    BaseObject.__call = function (Self)
        ChildCallCount = ChildCallCount + 1
        BaseObject__call(Self)
    end
    BaseObject()

    self:AssertEqual(BaseCallCount, 2)
    self:AssertEqual(ChildCallCount, 1)
end

return ExperimentsSuite
