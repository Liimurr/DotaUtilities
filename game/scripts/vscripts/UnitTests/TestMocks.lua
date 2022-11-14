local CTestSuite = require("TestSuite")
local CGlobalsMock = require("TestMocks.Globals")
local CPrecacheContext = require("TestMocks.PrecacheContext")
local CVectorMock = require("TestMocks.Vector")
local CEntityMock = require("TestMocks.Entity")
local CEntitiesMock = require("TestMocks.Entities")
local CParticleManagerMock = require("TestMocks.ParticleManager")

local TestMocksTestSuite = CTestSuite("TestMocksTestSuite")

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

    self:AssertEqual(Entities:FindByName(nil, "MyParticle01"):GetAbsOrigin(), CVectorMock(1, 2, 3))
    self:AssertEqual(Entities:FindByName(nil, "MyParticle02"):GetAbsOrigin(), CVectorMock(4, 5, 6))
    self:AssertEqual(Entities:FindByName(nil, "MyParticle03"):GetAbsOrigin(), CVectorMock(7, 8, 9))
    self:AssertEqual(Entities:FindByName(nil, "MyParticle04"), nil)
end

function TestMocksTestSuite:Test_ParticleManager()
    local ParticleManager = CParticleManagerMock()

    ParticleManager:CreateParticle( "my_particle01.vpk", 12, CEntityMock("Entity01"))
    ParticleManager:CreateParticle( "my_particle02.vpk", 18, CEntityMock("Entity02"))
    ParticleManager:CreateParticle( "my_particle03.vpk", 24, CEntityMock("Entity03"))
    ParticleManager:CreateParticle( "my_particle04.vpk", 30, CEntityMock("Entity04"))

    local RegisterParticles = ParticleManager:_GetRegisteredParticles()
    local NumRegisteredParticles = 0
    for _, _ in pairs(RegisterParticles) do
       NumRegisteredParticles = NumRegisteredParticles + 1 
    end
    self:AssertEqual(NumRegisteredParticles, 4)

    self:AssertEqual(RegisterParticles[0].ParticleAssetPath, "my_particle01.vpk")
    self:AssertEqual(RegisterParticles[0].ParticleAttachMode, 12)
    self:AssertEqual(RegisterParticles[0].OwningEntity:GetName(), "Entity01")

    self:AssertEqual(RegisterParticles[1].ParticleAssetPath, "my_particle02.vpk")
    self:AssertEqual(RegisterParticles[1].ParticleAttachMode, 18)
    self:AssertEqual(RegisterParticles[1].OwningEntity:GetName(), "Entity02")

    self:AssertEqual(RegisterParticles[2].ParticleAssetPath, "my_particle03.vpk")
    self:AssertEqual(RegisterParticles[2].ParticleAttachMode, 24)
    self:AssertEqual(RegisterParticles[2].OwningEntity:GetName(), "Entity03")

    self:AssertEqual(RegisterParticles[3].ParticleAssetPath, "my_particle04.vpk")
    self:AssertEqual(RegisterParticles[3].ParticleAttachMode, 30)
    self:AssertEqual(RegisterParticles[3].OwningEntity:GetName(), "Entity04")

    ParticleManager:SetParticleControl(2, 4, CVectorMock(14, 15, 32))

    self:AssertEqual(RegisterParticles[2].Controls[4], CVectorMock(14, 15, 32))

    ParticleManager:DestroyParticle(2)

    self:AssertEqual(RegisterParticles[2], nil)
end

return TestMocksTestSuite