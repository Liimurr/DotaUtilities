local Produce = require("Produce")
local Iota = require("ProduceExtensions.Iota")
local ProduceValues = require("ProduceExtensions.ProduceValues")

local CParticleTestUtilities = {}

---@param StartChar string
---@param EndChar string
---@param StartNum number
---@param EndNum number
---@return Channel
local ProduceTestParticleNames = function (StartChar, EndChar, StartNum, EndNum) 
    return Produce(function ()
        local ToParticleName = function (Letter, Number) return "particle_"..Letter..tostring(Number) end
        for Letter in Iota(string.byte(StartChar), string.byte(EndChar)) do
            for Number in Iota(StartNum, EndNum) do
                coroutine.yield(ToParticleName(string.char(Letter), Number))
            end
        end
    end)
end

---@param Entities table
---@param ProduceParticleNames Channel
---@return Channel
local ProduceTestParticleEntities = function (Entities, ProduceParticleNames) 
    return Produce(function ()
        for ParticleName in ProduceParticleNames do
            coroutine.yield(Entities:FindByName(ParticleName))
        end
    end)
end

---@param AttachmentModes table
---@return Channel
local ProduceTestAttachmentModes = function (AttachmentModes)
    return Produce (function () 
        while (true) do
            for _, AttachmentMode in ipairs(AttachmentModes) do
                coroutine.yield(AttachmentMode)
            end
        end
    end)
end

CParticleTestUtilities.TestParticleGenerator = function (
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
        GlobalContext = GlobalContext
    }

    function ParticleGenerator:Precache(PrecacheContext)
        for _, ParticleAsset in pairs(ParticleAssets) do
            self.GlobalContext.PrecacheResource("particle", ParticleAsset, PrecacheContext)
        end
    end

    local ParticleEntities = {}
    local ProduceParticleEntities = ProduceTestParticleEntities(Entities, ProduceValues(EntityNames))
    function ParticleGenerator:Activate()
        ParticleEntities = ProduceParticleEntities:Buffer()
    end

    function ParticleGenerator:_GetFoundParticleEntities()
        return ParticleEntities
    end

    -- local InitializeParticle = function (ParticleAsset, AttachmentMode, SetParticleControls, ParticleAttachmentEntity, ParticleControlsEntity)
    --     local ParticleIndex = ParticleManager:CreateParticle(ParticleAsset, AttachmentMode, ParticleAttachmentEntity)

    --     local ParticleControlsContext = {
    --         Asset = ParticleAsset,
    --         AttachmentMode = AttachmentMode,
    --         Entity = ParticleControlsEntity
    --     }
    --     SetParticleControls(ParticleIndex, ParticleControlsContext)
    -- end
    -- local GetParticleAttachmentEntityFunctions = {
    --     function (Entity) return Entity end,
    --     function () return nil end
    -- }
    -- table.insert(SetParticleControlsFunctions, function () end)
    -- function ParticleGenerator:PreGameInit()
    --     local NextEntity = ProduceValues(ParticleAttachmentEntities)
    --     for _, ParticleAsset in pairs(ParticleAssets) do
    --         for _, GetParticleAttachmentEntity in pairs(GetParticleAttachmentEntityFunctions) do
    --             for _, SetParticleControls in pairs(SetParticleControlsFunctions) do
    --                 for _, AttachmentMode in pairs(AttachmentModes) do
    --                     Entity = NextEntity()
    --                     AttachmentEntity = GetParticleAttachmentEntity(Entity)
    --                     InitializeParticle(
    --                         ParticleAsset,
    --                         AttachmentMode,
    --                         SetParticleControls,
    --                         AttachmentEntity,
    --                         Entity
    --                     )
    --                 end
    --             end
    --         end
    --     end
    -- end

    return ParticleGenerator
end

return CParticleTestUtilities