function be_animal(animalModel)

    local playerPed = PlayerPedId()
    local pedModel = GetHashKey(animalModel)

    Citizen.CreateThread(function() 

        -- loading for a particle effect
        local bib = 'core' -- the library will be core
        local particleName = 'exp_grd_grenade_smoke' -- particle effect name will be exp_grd_grenade_smoke
        -- more particle can be found here: https://vespura.com/fivem/particle-list/
        
        -- load the actual particle
        if not HasNamedPtfxAssetLoaded(bib) then
            RequestNamedPtfxAsset(bib)
            while not HasNamedPtfxAssetLoaded(bib) do
                Wait(0)
            end
        end

        SetPtfxAssetNextCall(bib) -- very important native for particles. If not set, particles will not be visible. 
        -- We are using the networked Particle effect, so its properly setup for MP
        -- checkout full documentation on fivem: https://docs.fivem.net/natives/?_0x6F60E89A7B64EE1D
        local Ptfx = StartNetworkedParticleFxLoopedOnEntity(particleName, PlayerPedId(), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, false, false, false)
        SetPtfxAssetNextCall(bib)
        local Ptfx2 = StartNetworkedParticleFxLoopedOnEntity(particleName, PlayerPedId(), 0.0, 0.0, -1.0, 0.0, 0.0, 0.0, 1.0, false, false, false)
        
        Citizen.Wait(2000) -- let the particle effect do its magic. 

        -- load the actual model. 
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Citizen.Wait(50)
        end
    
        if IsModelInCdimage(pedModel) and IsModelValid(pedModel) then
            SetPlayerModel(PlayerId(), pedModel) -- this is the actual native that changes the player skin (or model)
            SetPedDefaultComponentVariation(playerPed) -- Every ped as multiple variations, set default ones. 
        end
    
        StopParticleFxLooped(Ptfx, false) -- finnaly stop the particle effect
        StopParticleFxLooped(Ptfx2, false)

        SetModelAsNoLongerNeeded(pedModel) -- remove the loaded model. Cleanup done. 

    end)

end


RegisterCommand("be", function(source --[[ this is the player ID: a number ]], args --[[ this is a table of the arguments provided ]], rawCommand --[[ this is what the user entered ]])
        if args[1] then
            be_animal(args[1])
        end
end, false) -- false, in client we dont need Security check.