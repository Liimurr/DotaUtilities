local CUtilities = require("Utilities")

---@param ModuleName string
---@return boolean
local RunUnitTest = function (ModuleName)
    local TestSuite = require("UnitTests."..ModuleName)
    TestSuite()
    return TestSuite:IsPassing()
end

---@param ... string ModuleUnitTestNames 
return function (...)
    local AllPassing = true
    local FailingUnitTests = {}
    local RunUnitTest = function (ModuleName) 
        local UnitTestPassing = RunUnitTest(ModuleName)
        if not UnitTestPassing then
            table.insert(FailingUnitTests, ModuleName)
        end
        AllPassing = AllPassing and UnitTestPassing
    end

    local AllTestsStatus = function ()
        local FailingUnitTestsString = ""
        for Index,FailingUnitTest in next, FailingUnitTests do
            local Comma = ""
            if next(FailingUnitTests, Index) then
                Comma = ", "
            end
            FailingUnitTestsString = FailingUnitTestsString .. FailingUnitTest .. Comma
        end

        local PluralString = function ()
            if #FailingUnitTests > 1 then return "s" 
            else return "" end 
        end

        if AllPassing then 
            return "ALL UNIT TESTS PASSING" 
        else 
            return "FAILED "..#FailingUnitTests.." UnitTest"..PluralString()..": "..FailingUnitTestsString
        end
    end
    
    for _, UnitTest in ipairs(CUtilities.Pack(...)) do
        RunUnitTest(UnitTest)
    end

    print(AllTestsStatus())
end