local CGlobalsMock = require("TestMocks.Globals")
local CPrecacheContextMock = require("TestMocks.PrecacheContext")
local CEntitiesMock = require("TestMocks.Entities")
local CEntityMock = require("TestMocks.Entity")
local CVectorMock = require("TestMocks.Vector")
local CPArticleManagerMock = require("TestMocks.ParticleManager")
local CParticleTestUtilities = require("ParticleTestUtilities")
local CTestSuite = require("TestSuite")

local ParticleTestUtilitiesTestSuite = CTestSuite("ParticleTestUtilitiesTestSuite")

function ParticleTestUtilitiesTestSuite:Test_GenerateParticles()
    local GlobalMock = CGlobalsMock()
    local EntitiesMock = CEntitiesMock()
    local ParticleManagerMock = CPArticleManagerMock()
    EntitiesMock:_AddEnties({
        CEntityMock("particle_a1", CVectorMock(1, 2, 3)),
        CEntityMock("particle_a2", CVectorMock(4, 5, 6)),
        CEntityMock("particle_a3", CVectorMock(7, 8, 9))
    })

    local PrecacheContextMock = CPrecacheContextMock()
    local ParticleAssets =  {"particles/particle_asset1.vpk", "particles/particles_asset2.vpk"}
    local EntityNames = { "particle_a1", "particle_a2", "particle_a3" }
    local ParticleGenerator = CParticleTestUtilities.TestParticleGenerator(
        GlobalMock,
        EntitiesMock,
        nil,
        ParticleAssets,
        nil,
        EntityNames
    )

    ParticleGenerator:Precache(PrecacheContextMock)

    self:AssertEqual(GlobalMock:_IsResourceCached("nonexistent_asset"), false)
    for _, ParticleAsset in pairs(ParticleAssets) do
        self:AssertEqual(GlobalMock:_IsResourceCached(ParticleAsset), true)
        self:AssertEqual(GlobalMock:_GetResourceType(ParticleAsset), "particle")
        self:AssertEqual(GlobalMock:_GetPrecacheContext(ParticleAsset), PrecacheContextMock)
    end

    ParticleGenerator:Activate()

    local ParticleEntities = ParticleGenerator:_GetFoundParticleEntities()
    local ParticleEntitiesSet = {}
    for _, Entity in pairs(ParticleEntities) do
        ParticleEntitiesSet[Entity:GetName()] = Entity
    end 
    self:AssertEqual(#ParticleEntities, #EntityNames)
    self:AssertNotEqual(ParticleEntitiesSet["particle_a1"], nil)
    self:AssertEqual(ParticleEntitiesSet["particle_a1"]:GetAbsOrigin(), CVectorMock(1, 2, 3))
    self:AssertNotEqual(ParticleEntitiesSet["particle_a2"], nil)
    self:AssertEqual(ParticleEntitiesSet["particle_a2"]:GetAbsOrigin(),  CVectorMock(4, 5, 6))
    self:AssertNotEqual(ParticleEntitiesSet["particle_a3"], nil)
    self:AssertEqual(ParticleEntitiesSet["particle_a3"]:GetAbsOrigin(), CVectorMock(7, 8, 9))

end

return ParticleTestUtilitiesTestSuite