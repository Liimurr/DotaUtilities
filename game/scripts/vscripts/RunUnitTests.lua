local RunUnitTest = function (ModuleName)
    local TestSuite = require("UnitTests."..ModuleName)
    TestSuite()
end

return function ()
    RunUnitTest("Utilities")
    RunUnitTest("TestSuite")
    RunUnitTest("Experiments")
    RunUnitTest("Produce")
    RunUnitTest("ProduceExtensions")
    --RunUnitTest("Particle")
end