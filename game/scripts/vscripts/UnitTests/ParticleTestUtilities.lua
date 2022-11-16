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
        CEntityMock("particle_a3", CVectorMock(7, 8, 9)),
        CEntityMock("particle_a4"),
        CEntityMock("particle_a5"),
        CEntityMock("particle_a6"),
        CEntityMock("particle_a7"),
        CEntityMock("particle_a8"),
        CEntityMock("particle_a9"),
        CEntityMock("particle_a10"),
        CEntityMock("particle_a11"),
        CEntityMock("particle_a12"),
        CEntityMock("particle_a13"),
        CEntityMock("particle_a14"),
        CEntityMock("particle_a15"),
        CEntityMock("particle_a16")
    })

    local PrecacheContextMock = CPrecacheContextMock()
    local ParticleAssets =  {"particles/particle_asset1.vpk", "particles/particles_asset2.vpk"}
    local AttachmentModes = { 24, 42 }
    local EntityNames = CParticleTestUtilities.ProduceTestParticleNames("a", "a", 1, 16):Buffer()
    local SetParticleControls = { 
        function (ParticleIndex, ParticleControlsContext)  
            ParticleManagerMock:SetParticleControl(ParticleIndex, 12, ParticleControlsContext.Entity:GetAbsOrigin())   
        end 
    }
    local ParticleGenerator = CParticleTestUtilities.TestParticleGenerator(
        GlobalMock,
        EntitiesMock,
        ParticleManagerMock,
        ParticleAssets,
        AttachmentModes,
        EntityNames,
        SetParticleControls
    )

    self:AssertNotEqual(ParticleGenerator, nil)
    if (not ParticleGenerator) then
        return
    end

    ParticleGenerator:Precache(PrecacheContextMock)

    self:AssertEqual(GlobalMock:_IsResourceCached("nonexistent_asset"), false)
    for _, ParticleAsset in pairs(ParticleAssets) do
        self:AssertEqual(GlobalMock:_IsResourceCached(ParticleAsset), true)
        self:AssertEqual(GlobalMock:_GetResourceType(ParticleAsset), "particle")
        self:AssertEqual(GlobalMock:_GetPrecacheContext(ParticleAsset), PrecacheContextMock)
    end

    ParticleGenerator:Activate()

    local FoundParticleEntities = ParticleGenerator:_GetFoundParticleEntities()
    self:AssertEqual(#FoundParticleEntities, #EntityNames)
    local ParticleEntitiesSet = {}
    for _, Entity in pairs(FoundParticleEntities) do
        ParticleEntitiesSet[Entity:GetName()] = Entity
    end
    self:AssertNotEqual(ParticleEntitiesSet["particle_a1"], nil)
    self:AssertEqual(ParticleEntitiesSet["particle_a1"]:GetAbsOrigin(), CVectorMock(1, 2, 3))
    self:AssertNotEqual(ParticleEntitiesSet["particle_a2"], nil)
    self:AssertEqual(ParticleEntitiesSet["particle_a2"]:GetAbsOrigin(),  CVectorMock(4, 5, 6))
    self:AssertNotEqual(ParticleEntitiesSet["particle_a3"], nil)
    self:AssertEqual(ParticleEntitiesSet["particle_a3"]:GetAbsOrigin(), CVectorMock(7, 8, 9))

    ParticleGenerator:PreGameInit()

    -- for _, ParticleAsset in pairs(ParticleAssets) do
    --     for _, GetParticleAttachmentEntity in pairs(GetParticleAttachmentEntityFunctions) do
    --         for _, SetParticleControls in pairs(SetParticleControlsFunctions) do
    --             for _, AttachmentMode in pairs(AttachmentModes) do
    -- ParticleIndex = ParticleIndex,
    -- ParticleAssetPath = ParticleAssetPath,
    -- ParticleAttachMode = ParticleAttachMode,
    -- OwningEntity = OwningEntity,
    -- Controls = {}
    local RegisteredParticles = ParticleManagerMock:_GetRegisteredParticles()
    ExpectedParticleValues = {
        [0] = {
            ParticleIndex = 0,
            ParticleAssetPath = "particles/particle_asset1.vpk",
            ParticleAttachMode = 24,
            OwningEntity = EntitiesMock:FindByName(nil, "particle_a1"),
            Controls = {
                [12] = CVectorMock(1,2,3)
            },
            NumControls = 1
        },
        [1] = {
            ParticleIndex = 1,
            ParticleAssetPath = "particles/particle_asset1.vpk",
            ParticleAttachMode = 42,
            OwningEntity = EntitiesMock:FindByName(nil, "particle_a2"),
            Controls = {
                [12] = CVectorMock(4,5,6)
            },
            NumControls = 1
        },
        [2] = {
            ParticleIndex = 2,
            ParticleAssetPath = "particles/particle_asset1.vpk",
            ParticleAttachMode = 24,
            OwningEntity = EntitiesMock:FindByName(nil, "particle_a3"),
            Controls = {},
            NumControls = 0
        },
        [3] = {
            ParticleIndex = 3,
            ParticleAssetPath = "particles/particle_asset1.vpk",
            ParticleAttachMode = 42,
            OwningEntity = EntitiesMock:FindByName(nil, "particle_a4"),
            Controls = {},
            NumControls = 0
        },
        [4] = {
            ParticleIndex = 4,
            ParticleAssetPath = "particles/particle_asset1.vpk",
            ParticleAttachMode = 24,
            OwningEntity = nil,
            Controls = {
                [12] = CVectorMock(0,0,0)
            },
            NumControls = 1
        },
        [5] = {
            ParticleIndex = 5,
            ParticleAssetPath = "particles/particle_asset1.vpk",
            ParticleAttachMode = 42,
            OwningEntity = nil,
            Controls = {
                [12] = CVectorMock(0,0,0)
            },
            NumControls = 1
        },
        [6] = {
            ParticleIndex = 6,
            ParticleAssetPath = "particles/particle_asset1.vpk",
            ParticleAttachMode = 24,
            OwningEntity = nil,
            Controls = {},
            NumControls = 0
        },
        [7] = {
            ParticleIndex = 7,
            ParticleAssetPath = "particles/particle_asset1.vpk",
            ParticleAttachMode = 42,
            OwningEntity = nil,
            Controls = {},
            NumControls = 0
        },
        [8] = {
            ParticleIndex = 8,
            ParticleAssetPath = "particles/particles_asset2.vpk",
            ParticleAttachMode = 24,
            OwningEntity = EntitiesMock:FindByName(nil, "particle_a9"),
            Controls = {
                [12] = CVectorMock(0,0,0)
            },
            NumControls = 1
        },
        [9] = {
            ParticleIndex = 9,
            ParticleAssetPath = "particles/particles_asset2.vpk",
            ParticleAttachMode = 42,
            OwningEntity = EntitiesMock:FindByName(nil, "particle_a10"),
            Controls = {
                [12] = CVectorMock(0,0,0)
            },
            NumControls = 1
        },
        [10] = {
            ParticleIndex = 10,
            ParticleAssetPath = "particles/particles_asset2.vpk",
            ParticleAttachMode = 24,
            OwningEntity = EntitiesMock:FindByName(nil, "particle_a11"),
            Controls = {},
            NumControls = 0
        },
        [11] = {
            ParticleIndex = 11,
            ParticleAssetPath = "particles/particles_asset2.vpk",
            ParticleAttachMode = 42,
            OwningEntity = EntitiesMock:FindByName(nil, "particle_a12"),
            Controls = {},
            NumControls = 0
        },
        [12] = {
            ParticleIndex = 12,
            ParticleAssetPath = "particles/particles_asset2.vpk",
            ParticleAttachMode = 24,
            OwningEntity = nil,
            Controls = {
                [12] = CVectorMock(0,0,0)
            },
            NumControls = 1
        },
        [13] = {
            ParticleIndex = 13,
            ParticleAssetPath = "particles/particles_asset2.vpk",
            ParticleAttachMode = 42,
            OwningEntity = nil,
            Controls = {
                [12] = CVectorMock(0,0,0)
            },
            NumControls = 1
        },
        [14] = {
            ParticleIndex = 14,
            ParticleAssetPath = "particles/particles_asset2.vpk",
            ParticleAttachMode = 24,
            OwningEntity = nil,
            Controls = {},
            NumControls = 0
        },
        [15] = {
            ParticleIndex = 15,
            ParticleAssetPath = "particles/particles_asset2.vpk",
            ParticleAttachMode = 42,
            OwningEntity = nil,
            Controls = {},
            NumControls = 0
        },
    }

    local GetTableCount = function (Table)
        local Count = 0
        for _, _ in pairs(Table) do
            Count = Count + 1
        end
        return Count
    end

    local GetGroundTruth = function ()

        local Out = ""
        
        local LexOwningEntity = function (Entity)
            if not Entity then return "nil" end
            return "EntitiesMock:FindByName(nil, \""..Entity:GetName().."\")"
        end
    

        local LexControls = function (Controls)
            if GetTableCount(Controls) > 0 then
                local Out = "{\n"
                for ControlIndex, ControlValue in pairs(Controls) do
                    Out = Out.."        ["..ControlIndex.."]".." = CVectorMock("..tostring(ControlValue)..")\n"
                end
                Out = Out.."    }"
                return Out
            else
                return "{}"
            end
        end

        for ParticleIndex, V in pairs(RegisteredParticles) do
            Out = Out..string.format(
                "[%d] = {\n"..
                "    ParticleIndex = %d,\n"..
                "    ParticleAssetPath = \"%s\",\n"..
                "    ParticleAttachMode = %d,\n"..
                "    OwningEntity = %s,\n"..
                "    Controls = %s,\n"..
                "    NumControls = %d\n"..
                "},\n", 
            ParticleIndex, 
            ParticleIndex,
            V.ParticleAssetPath,
            V.ParticleAttachMode,
            LexOwningEntity(V.OwningEntity),
            LexControls(V.Controls),
            GetTableCount(V.Controls)
        )
        end

        return Out
    end

    for ParticleIndex, ExpectedParticleValue in pairs(ExpectedParticleValues) do
        ActualValue = RegisteredParticles[ParticleIndex]
        self:AssertEqual(ActualValue.ParticleIndex, ExpectedParticleValue.ParticleIndex)
        self:AssertEqual(ActualValue.ParticleAssetPath, ExpectedParticleValue.ParticleAssetPath)
        self:AssertEqual(ActualValue.ParticleAttachMode, ExpectedParticleValue.ParticleAttachMode)
        self:AssertEqual(ActualValue.OwningEntity, ExpectedParticleValue.OwningEntity)
        self:AssertEqual(GetTableCount(ActualValue.Controls), ExpectedParticleValue.NumControls)
        for ControlIndex, ExpectedControlValue in pairs(ExpectedParticleValue.Controls) do
            self:AssertEqual(ActualValue.Controls[ControlIndex], ExpectedControlValue)
        end
    end
end

return ParticleTestUtilitiesTestSuite