local QBCore = exports['qb-core']:GetCoreObject()
local currentMask = nil
local isMaskOff = false
local currentVest = nil
local isVestOff = false

-- Animation function for mask interaction
local function PlayMaskAnimation()
    local ped = PlayerPedId()
    
    -- Load animation dictionary (facepalm 4 from wsemotes)
    RequestAnimDict('anim@mp_player_intupperface_palm')
    while not HasAnimDictLoaded('anim@mp_player_intupperface_palm') do
        Wait(0)
    end
    
    -- Play the facepalm 4 animation
    TaskPlayAnim(ped, 'anim@mp_player_intupperface_palm', 'idle_a', 8.0, -8.0, -1, 49, 0, false, false, false)
    
    -- Wait for animation to play
    Wait(1200)
    
    -- Clear animation
    ClearPedTasksImmediately(ped)
    
    -- Remove animation dictionary from memory
    RemoveAnimDict('anim@mp_player_intupperface_palm')
end

-- Animation function for vest interaction
local function PlayVestAnimation()
    local ped = PlayerPedId()
    
    -- Load animation dictionary (taking off/putting on clothes)
    RequestAnimDict('clothingshoes')
    while not HasAnimDictLoaded('clothingshoes') do
        Wait(0)
    end
    
    -- Play the vest animation
    TaskPlayAnim(ped, 'clothingshoes', 'try_shoes_positive_d', 8.0, -8.0, -1, 49, 0, false, false, false)
    
    -- Wait for animation to play
    Wait(1500)
    
    -- Clear animation
    ClearPedTasksImmediately(ped)
    
    -- Remove animation dictionary from memory
    RemoveAnimDict('clothingshoes')
end

-- Function to check if player is wearing a mask
local function IsWearingMask()
    local ped = PlayerPedId()
    local drawable = GetPedDrawableVariation(ped, 1)
    return drawable ~= 0
end

-- Function to check if player is wearing a vest
local function IsWearingVest()
    local ped = PlayerPedId()
    local drawable = GetPedDrawableVariation(ped, 9)
    return drawable ~= 0
end

-- Function to remove mask
local function RemoveMask()
    local ped = PlayerPedId()
    
    if not IsWearingMask() then
        TriggerEvent('QBCore:Notify', Config.Notifications.no_mask, 'error')
        return
    end
    
    -- Store current mask data before animation
    currentMask = {
        drawable = GetPedDrawableVariation(ped, 1),
        texture = GetPedTextureVariation(ped, 1),
        palette = GetPedPaletteVariation(ped, 1)
    }
    
    -- Play animation then remove mask
    Citizen.CreateThread(function()
        PlayMaskAnimation()
        -- Remove mask (set to 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        isMaskOff = true
        TriggerEvent('QBCore:Notify', Config.Notifications.mask_removed, 'success')
    end)
end

-- Function to put mask back on
local function PutMaskOn()
    local ped = PlayerPedId()
    
    if not currentMask or not isMaskOff then
        TriggerEvent('QBCore:Notify', Config.Notifications.no_mask, 'error')
        return
    end
    
    -- Play animation then put mask on
    Citizen.CreateThread(function()
        PlayMaskAnimation()
        -- Restore mask
        SetPedComponentVariation(ped, 1, currentMask.drawable, currentMask.texture, currentMask.palette)
        isMaskOff = false
        currentMask = nil
        TriggerEvent('QBCore:Notify', Config.Notifications.mask_added, 'success')
    end)
end

-- Function to remove vest
local function RemoveVest()
    local ped = PlayerPedId()
    
    if not IsWearingVest() then
        TriggerEvent('QBCore:Notify', Config.Notifications.no_vest, 'error')
        return
    end
    
    -- Store current vest data before animation
    currentVest = {
        drawable = GetPedDrawableVariation(ped, 9),
        texture = GetPedTextureVariation(ped, 9),
        palette = GetPedPaletteVariation(ped, 9)
    }
    
    -- Play animation then remove vest
    Citizen.CreateThread(function()
        PlayVestAnimation()
        -- Remove vest (set to 0)
        SetPedComponentVariation(ped, 9, 0, 0, 0)
        isVestOff = true
        TriggerEvent('QBCore:Notify', Config.Notifications.vest_removed, 'success')
    end)
end

-- Function to put vest back on
local function PutVestOn()
    local ped = PlayerPedId()
    
    if not currentVest or not isVestOff then
        TriggerEvent('QBCore:Notify', Config.Notifications.no_vest, 'error')
        return
    end
    
    -- Play animation then put vest on
    Citizen.CreateThread(function()
        PlayVestAnimation()
        -- Restore vest
        SetPedComponentVariation(ped, 9, currentVest.drawable, currentVest.texture, currentVest.palette)
        isVestOff = false
        currentVest = nil
        TriggerEvent('QBCore:Notify', Config.Notifications.vest_added, 'success')
    end)
end

-- Register commands
RegisterCommand(Config.Commands.maskoff, function()
    RemoveMask()
end, false)

RegisterCommand(Config.Commands.maskon, function()
    PutMaskOn()
end, false)

RegisterCommand(Config.Commands.vestoff, function()
    RemoveVest()
end, false)

RegisterCommand(Config.Commands.veston, function()
    PutVestOn()
end, false)

-- Reset mask and vest state when player respawns
AddEventHandler('playerSpawned', function()
    currentMask = nil
    isMaskOff = false
    currentVest = nil
    isVestOff = false
end)
