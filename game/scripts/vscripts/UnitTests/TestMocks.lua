local CTestSuite = require("TestSuite")
local CGlobalsMock = require("TestMocks.Globals")
local CPrecacheContext = require("TestMocks.PrecacheContext")
local CVectorMock = require("TestMocks.Vector")
local CEntityMock = require("TestMocks.Entity")
local CEntitiesMock = require("TestMocks.Entities")

local TestMocksTestSuite = CTestSuite("MocksTestSuite")

function TestMocksTestSuite:Test_PrecacheContext()
    local PrecacheContext = CPrecacheContext()
    self:AssertEqual(tostring(PrecacheContext),  "MockPrecacheContext:"..string.format("%p", PrecacheContext))
end

function TestMocksTestSuite:Test_Globals()
    local GlobalsMock = CGlobalsMock()
    local PrecacheContext = CPrecacheContext()
    
    GlobalsMock.PrecacheResource("particle", "my_particle.vpk", PrecacheContext)
    self:AssertEqual(GlobalsMock:_IsResourceCached("my_particle.vpk"), true)
    self:AssertEqual(GlobalsMock:_GetPrecacheContext("my_particle.vpk"), PrecacheContext)
    self:AssertEqual(GlobalsMock:_GetResourceType("my_particle.vpk"), "particle")
end

function TestMocksTestSuite:Test_Vector()
    local TestVector = CVectorMock(13, 14, 15)
    self:AssertEqual(TestVector.X, 13)
    self:AssertEqual(TestVector.Y, 14)
    self:AssertEqual(TestVector.Z, 15)
    local Other = CVectorMock(13, 14, 15)
    self:AssertEqual(TestVector, Other)
    self:AssertNotEqual(TestVector, CVectorMock(99, 14, 15))
    self:AssertEqual(tostring(TestVector), "13,14,15")
end

function TestMocksTestSuite:Test_Entity()
    local TestEntity = CEntityMock("MyParticle01")
    TestEntity:_SetAbsOrigin(CVectorMock(50, 100, 150))
    self:AssertEqual(TestEntity:GetName(), "MyParticle01")
    self:AssertEqual(TestEntity:GetAbsOrigin(), CVectorMock(50, 100, 150))
end

function TestMocksTestSuite:Test_Entities()
    local Entities = CEntitiesMock()

    Entities:_AddEnties({
        CEntityMock("MyParticle01", CVectorMock(1, 2, 3)),
        CEntityMock("MyParticle02", CVectorMock(4, 5, 6)),
        CEntityMock("MyParticle03", CVectorMock(7, 8, 9)),
    })

    self:AssertEqual(Entities:FindByName("MyParticle01"):GetAbsOrigin(), CVectorMock(1, 2, 3))
    self:AssertEqual(Entities:FindByName("MyParticle02"):GetAbsOrigin(), CVectorMock(4, 5, 6))
    self:AssertEqual(Entities:FindByName("MyParticle03"):GetAbsOrigin(), CVectorMock(7, 8, 9))
    self:AssertEqual(Entities:FindByName("MyParticle04"), nil)
end

return TestMocksTestSuite