local CParticleMock = require("TestMocks.Particle")

local NewParticleManagerMock = function()
    ---@class ParticleManagerMock
    local ParticleManagerMock = { 
        NextParticleIndex = 0,
        RegisteredParticles = {}
    }

    ---@param ParticleAssetPath string
    ---@param ParticleAttachMode integer
    ---@param OwningEntity table
    ---@return integer
    function ParticleManagerMock:CreateParticle(ParticleAssetPath, ParticleAttachMode, OwningEntity)
        local OutParticleIndex = self.NextParticleIndex
        self.NextParticleIndex = self.NextParticleIndex+1
        self.RegisteredParticles[OutParticleIndex] = CParticleMock(OutParticleIndex, ParticleAssetPath, ParticleAttachMode, OwningEntity)
        return OutParticleIndex
    end

    ---@param ParticleIndex integer
    ---@param bDestroyImmediate boolean
    function ParticleManagerMock:DestroyParticle(ParticleIndex, bDestroyImmediate)
        self.RegisteredParticles[ParticleIndex] = nil
    end

    ---@param ParticleIndex integer
    ---@param ControlIndex integer
    ---@param ControlData Vector
    function ParticleManagerMock:SetParticleControl(ParticleIndex, ControlIndex, ControlData)
        self.RegisteredParticles[ParticleIndex].Controls[ControlIndex] = ControlData
    end

    --- TEST only
    --- @return ParticleMock[]
    function ParticleManagerMock:_GetRegisteredParticles()
        return self.RegisteredParticles
    end

    return ParticleManagerMock
end

local NewCParticleManagerMock = function ()
    CParticleManagerMockMetaTable = CParticleManagerMockMetaTable or {}

    ---@return ParticleManagerMock
    function CParticleManagerMockMetaTable:__call()
        return NewParticleManagerMock()
    end

    return setmetatable({}, CParticleManagerMockMetaTable)
end

return NewCParticleManagerMock()