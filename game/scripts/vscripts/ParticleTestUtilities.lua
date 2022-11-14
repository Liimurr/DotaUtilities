local CUtilities = require("Utilities")
local Produce = require("Produce")
local Iota = require("ProduceExtensions.Iota")
local ProduceValues = require("ProduceExtensions.ProduceValues")

local MakeExpectNonNilArgument = function (FunctionName) 
    return function (Arg, ArgPosition) return CUtilities.ExpectNonNilArgument(Arg, FunctionName, ArgPosition) end 
end

local MakeExpectArrayOfSizeGreaterThanOrEqualTo = function (FunctionName)
    return function (Arg, ArgPosition, ArraySize) return CUtilities.ExpectArrayOfSizeGreaterThanOrEqualTo(Arg, FunctionName, ArgPosition, ArraySize) end
end

local CParticleTestUtilities = {}

---@param StartChar string
---@param EndChar string
---@param StartNum number
---@param EndNum number
---@return Channel
CParticleTestUtilities.ProduceTestParticleNames = function (StartChar, EndChar, StartNum, EndNum) 
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
            local Entity = Entities:FindByName(nil, ParticleName)
            if not Entity then
                print("WARNING: Entity "..ParticleName.." did not exist")
            end
            coroutine.yield(Entity)
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

---@param GlobalContext any
---@param Entities any
---@param ParticleManager any
---@param ParticleAssets string[]
---@param AttachmentModes integer[]
---@param EntityNames string[]
---@param SetParticleControlsFunctions fun(ParticleIndex : integer, ParticleControlsContext : ParticleControlsContext)[]
---@return ParticleGenerator | nil
CParticleTestUtilities.TestParticleGenerator = function (
    GlobalContext,
    Entities,
    ParticleManager,
    ParticleAssets,
    AttachmentModes,
    EntityNames,
    SetParticleControlsFunctions
)
    local ExpectNonNilArgument = MakeExpectNonNilArgument("TestParticleGenerator")
    local ExpectArrayOfSizeGreaterThanOrEqualTo = MakeExpectArrayOfSizeGreaterThanOrEqualTo("TestParticleGenerator")

    if
        not ExpectNonNilArgument(GlobalContext, 1) or
        not ExpectNonNilArgument(Entities, 2) or
        not ExpectNonNilArgument(ParticleManager, 3) or
        not ExpectArrayOfSizeGreaterThanOrEqualTo(ParticleAssets, 1, 4) or
        not ExpectArrayOfSizeGreaterThanOrEqualTo(AttachmentModes, 1, 5) or
        not ExpectArrayOfSizeGreaterThanOrEqualTo(EntityNames, 1, 6)
    then
        return nil
    end

    SetParticleControlsFunctions = SetParticleControlsFunctions or {}

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

    local InitializeParticle = function (ParticleAsset, AttachmentMode, SetParticleControls, ParticleAttachmentEntity, ParticleControlsEntity)
        local ParticleIndex = ParticleManager:CreateParticle(ParticleAsset, AttachmentMode, ParticleAttachmentEntity)

        ---@class ParticleControlsContext
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
        local NextEntity = ProduceValues(ParticleEntities)
        for _, ParticleAsset in pairs(ParticleAssets) do
            for _, GetParticleAttachmentEntity in pairs(GetParticleAttachmentEntityFunctions) do
                for _, SetParticleControls in pairs(SetParticleControlsFunctions) do
                    for _, AttachmentMode in pairs(AttachmentModes) do

                        Entity = NextEntity()
                        if not Entity then
                            local NumRequiredEntities = #ParticleAssets * #GetParticleAttachmentEntityFunctions * #SetParticleControlsFunctions * #AttachmentModes
                            error("Ran out of particle entities. Need "..NumRequiredEntities..", but got "..#ParticleEntities)
                        end

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

return CParticleTestUtilities