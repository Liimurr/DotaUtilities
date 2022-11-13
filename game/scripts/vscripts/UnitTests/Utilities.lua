local CTestSuite = require("TestSuite")
local CUtilities = require("Utilities")

local UtilitiesTestSuite = CTestSuite("UtilitiesTestSuite")

function UtilitiesTestSuite:Test_Pack()
    local Pack = CUtilities.Pack(100, 200, 300)
    self:AssertEqual(Pack[1], 100)
    self:AssertEqual(Pack[2], 200)
    self:AssertEqual(Pack[3], 300)
end

function UtilitiesTestSuite:Test_Unpack()
    local _1, _2, _3 = CUtilities.Unpack({100, 200, 300})
    self:AssertEqual(_1, 100)
    self:AssertEqual(_2, 200)
    self:AssertEqual(_3, 300)
end

function UtilitiesTestSuite:Test_ToBoolean()
    local Table = {}
    self:AssertEqual(tostring(CUtilities.ToBoolean(Table)), "true")

    local Nil = nil
    self:AssertEqual(tostring(CUtilities.ToBoolean(Nil)), "false")
end

function UtilitiesTestSuite:Test_IsNearlyEqual()
    local A = 5
    local B = 10
    local C = 5.00001
    self:AssertEqual(CUtilities.IsNearlyEqual(A, B), false)
    self:AssertEqual(CUtilities.IsNearlyEqual(A, C), true)
    self:AssertEqual(CUtilities.IsNearlyEqual(A, B, 6), true)
end

return UtilitiesTestSuite