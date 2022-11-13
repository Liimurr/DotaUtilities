local CParticleTestUtilities = require("ParticleTestUtilities")
local CTestSuite = require("TestSuite")
local ParticleTestSuite = CTestSuite("ParticleTestSuite")

local TestSuite__call = ParticleTestSuite.__call
function ParticleTestSuite:__call(GlobalContext, Entities, ParticleManager)
    self.GlobalContext = GlobalContext
    self.Entities = Entities
    self.ParticleManager = ParticleManager
    TestSuite__call(self)
end

function ParticleTestSuite:Test_GenerateParticles()
    local CGlobalsMock = require("TestMocks.Globals")
    local CPrecacheContextMock = require("TestMocks.PrecacheContext")
    local GlobalMock = CGlobalsMock()
    local PrecacheContextMock = CPrecacheContextMock()
    local ParticleAssets =  {"my_particle01.vpk", "my_particle02.vpk"}
    local ParticleGenerator = CParticleTestUtilities.TestParticleGenerator(
        GlobalMock,
        nil,
        nil,
        {"my_particle01.vpk", "my_particle02.vpk"}
    )

    ParticleGenerator:Precache(PrecacheContextMock)

    self:AssertEqual(GlobalMock:_IsResourceCached("nonexistant_asset"), false)
    for _, ParticleAsset in pairs(ParticleAssets) do
        self:AssertEqual(GlobalMock:_IsResourceCached(ParticleAsset), true)
        self:AssertEqual(GlobalMock:_GetResourceType(ParticleAsset), "particle")
        self:AssertEqual(GlobalMock:_GetPrecacheContext(ParticleAsset), PrecacheContextMock)
    end
end

return ParticleTestSuite