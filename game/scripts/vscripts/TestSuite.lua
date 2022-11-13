local CUtilities = require("Utilities")

---@param TestName string
---@return TestSuite
local NewTestSuite = function(TestName)
    local Error = function (Msg) error(Msg) end
    local PrintLine = function (...) print(TestName, ": ", ...) end

    ---@class TestSuite
    local TestSuite = { bIsPassing = true }
    local TestFailed = function (ErrorMsg) 
        PrintLine(ErrorMsg)
        TestSuite.bIsPassing = false
    end

    --- Override this to return false if you want errors to cancel all following child tests of this test
    --- By default this returns true and will continue running following child tests even when one fails
    ---@return boolean
    function TestSuite:ContinueOnError()
        return true
    end

    --- Gets the file and line in string form of an assertion failure
    ---@return string
    local GetAssertTraceBackMsg = function ()
        local DebugInfo = debug.getinfo(3, "Sl")
        return string.format("%s:%s", DebugInfo.short_src, DebugInfo.currentline)
    end

    ---Override this function to return true to print expected and actual values in Asserts even when succeeding, by default asserts only print on failure.
    ---@return boolean
    function TestSuite:PrintOnSuccess()
        return false
    end

    ---Use in a child test to assert that two values are equal, if they are not equal then the test fails
    ---@param Actual any
    ---@param Expected any
    function TestSuite:AssertEqual(Actual, Expected)
        if Actual ~= Expected then
            Error(string.format("AssertEqual failed. %s: Actual: %s, Expected: %s", GetAssertTraceBackMsg(), Actual, Expected))
        else
            if (self:PrintOnSuccess()) then 
                PrintLine(string.format("AssertEqual passed: Actual: %s, Expected: %s", Actual, Expected))
            end
        end
    end

    ---Use in a child test to assert that two values are not equal, if they are equal then the test fails
    ---@param Actual any
    ---@param NotExpected any
    function TestSuite:AssertNotEqual(Actual, NotExpected)
        if Actual == NotExpected then
            Error(string.format("AssertNotEqual failed. %s: Actual: %s, NotExpected: %s", GetAssertTraceBackMsg(), Actual, NotExpected))
        else
            if (self:PrintOnSuccess()) then 
                PrintLine(string.format("AssertNotEqual passed: Actual: %s, NotExpected: %s", Actual, NotExpected))
            end
        end
    end

    ---If any child tests failed is this will return false, otherwise returns true
    ---@return boolean
    function TestSuite:IsPassing()
        return self.bIsPassing
    end

    ---Invokes all tests owned by this TestSuite
    ---@param ...any
    function TestSuite:__call(...)
        VarArgs = {...}
        local Status, ErrorMsg = pcall(function ()
            for Key, SubTest in pairs(TestSuite) do
                if string.sub(Key, 1,5) == "Test_" and type(SubTest) == "function" then
                    PrintLine("Running Sub Test: ", Key)
                    if (self:ContinueOnError()) then
                        local Status, ErrorMsg = pcall(function () SubTest(self, CUtilities.Unpack(VarArgs)) end)
                        if (not Status) then TestFailed(ErrorMsg) end
                    else
                        SubTest(self, CUtilities.Unpack(VarArgs))
                    end
                end
            end
        end)
        if (not Status) then 
            TestFailed(ErrorMsg)
        end

        local sepearator = "--------------------------------------------"
        if (self.bIsPassing) then
            PrintLine("PASSED\n", sepearator)
        else
            PrintLine("FAILED\n", sepearator)
        end
    end
    
    return setmetatable(TestSuite, TestSuite)
end

local NewCTestSuite = function ()
    ---@class CTestSuite
    local CTestSuite = {}
    function CTestSuite:__call(TestName)
        return NewTestSuite(TestName)
    end
    return setmetatable(CTestSuite, CTestSuite)
end

return NewCTestSuite()