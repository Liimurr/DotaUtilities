local NewCParticleMock = function ()
    CParticleMock = CParticleMock or {}
    
    ---@param ParticleIndex number
    ---@param ParticleAssetPath string
    ---@param ParticleAttachMode number
    ---@param OwningEntity table
    ---@return ParticleMock
    function CParticleMock:__call(ParticleIndex, ParticleAssetPath, ParticleAttachMode, OwningEntity)
        ---@class ParticleMock
        return {
            ParticleIndex = ParticleIndex,
            ParticleAssetPath = ParticleAssetPath,
            ParticleAttachMode = ParticleAttachMode,
            OwningEntity = OwningEntity,
            Controls = {}
        }
    end

    return setmetatable({}, CParticleMock)
end

return NewCParticleMock()