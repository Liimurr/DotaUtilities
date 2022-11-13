local ProduceValues = require("ProduceValues")
local CTestSuite = require("TestSuite")
local ParticleTestSuite = CTestSuite("ParticleTestSuite")

local NewParticleGenerator = function (
    GlobalContext,
    Entities,
    ParticleManager,
    ParticleAssets,
    AttachmentModes,
    EntityNames,
    SetParticleControlsFunctions
)
    ---@class ParticleGenerator
    local ParticleGenerator = {
        GlobalContext=GlobalContext, 
        Entities=Entities,
        ParticleManager=ParticleManager
    }

    function ParticleGenerator:Precache(PrecacheContext)
        for _, ParticleAsset in pairs(ParticleAssets) do
            self.GlobalContext.PrecacheResource("particle", ParticleAsset, PrecacheContext)
        end
    end

    local ParticleAttachmentEntities = {}
    local ProduceParticleAttachmentEntities = ProduceTestParticleEntities(Entities, ProduceValues(EntityNames))
    function ParticleGenerator:Activate()
        ProduceParticleAttachmentEntities:ConsumeEach(function (OwningEntity) table.insert(ParticleAttachmentEntities, OwningEntity) end)
    end

    local InitializeParticle = function (ParticleAsset, AttachmentMode, SetParticleControls, ParticleAttachmentEntity, ParticleControlsEntity)
        local ParticleIndex = ParticleManager:CreateParticle(ParticleAsset, AttachmentMode, ParticleAttachmentEntity)

        local ParticleControlsContext = {
            Asset = ParticleAsset,
            AttachmentMode = AttachmentMode,
            Entity = ParticleControlsEntity
        }
        SetParticleControls(ParticleIndex, ParticleControlsContext)
    end
    local GetParticleAttachmentEntityFunctions = {
        function (Entity) return Entity end,
        function () return nil end
    }
    table.insert(SetParticleControlsFunctions, function () end)
    function ParticleGenerator:PreGameInit()
        local NextEntity = ProduceValues(ParticleAttachmentEntities)
        for _, ParticleAsset in pairs(ParticleAssets) do
            for _, GetParticleAttachmentEntity in pairs(GetParticleAttachmentEntityFunctions) do
                for _, SetParticleControls in pairs(SetParticleControlsFunctions) do
                    for _, AttachmentMode in pairs(AttachmentModes) do
                        Entity = NextEntity()
                        AttachmentEntity = GetParticleAttachmentEntity(Entity)
                        InitializeParticle(
                            ParticleAsset,
                            AttachmentMode,
                            SetParticleControls,
                            AttachmentEntity,
                            Entity
                        )
                    end
                end
            end
        end
    end

    return ParticleGenerator
end

local TestSuite__call = ParticleTestSuite.__call
function ParticleTestSuite:__call(GlobalContext, Entities, ParticleManager)
    self.GlobalContext = GlobalContext
    self.Entities = Entities
    self.ParticleManager = ParticleManager
    TestSuite__call(self)
end

function ParticleTestSuite:Test_PointParticle()
    local ParticleGenerator = NewParticleGenerator()
    ParticleGenerator:Precache(nil)
    ParticleGenerator:Activate()
    ParticleGenerator:PreGameInit()
end

return ParticleTestSuite

