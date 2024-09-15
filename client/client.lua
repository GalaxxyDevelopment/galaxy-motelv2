local function LoadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(500)
    end
end

local function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(500)
    end
end

local function PlayDoorAnimation()
    local playerPed = PlayerPedId()
    local doorDict = 'anim@heists@keycard@'
    local doorAnim = 'exit'
    local blackoutTime = 1000
    LoadAnimDict(doorDict)

    PlaySoundFrontend(-1, "Key_Pick", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", true)
    TaskPlayAnim(playerPed, doorDict, doorAnim, 8.0, -8.0, 1600, 1, 0, false, false, false)

    DoScreenFadeOut(500)
    Wait(blackoutTime)
    DoScreenFadeIn(500)
end

local function CreateNPC()
    LoadModel(Config.NpcModel)
    local npc = CreatePed(0, Config.NpcModel, Config.MotelEnter.x, Config.MotelEnter.y, Config.MotelEnter.z - 1.0, Config.MotelEnter.w, false, true)
    SetEntityInvincible(npc, true)
    FreezeEntityPosition(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)

    exports['qb-target']:AddTargetEntity(npc, {
        options = {
            {
                type = "server",
                event = "galaxy:checkRoom",
                icon = "fas fa-door-open",
                label = "Odaya Gir",
            }
        },
        distance = 2.0
    })
end

RegisterNetEvent('galaxy:teleportPlayer')
AddEventHandler('galaxy:teleportPlayer', function(room)
    PlayDoorAnimation()
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, 346.58, -1012.76, -99.2, false, false, false, true)
    SetEntityHeading(playerPed, 353.97)
end)

RegisterNetEvent('galaxy:loadInterior')
AddEventHandler('galaxy:loadInterior', function()
    local interiorID = 206337
    LoadInterior(interiorID)
end)

RegisterNetEvent('galaxy:openStash')
AddEventHandler('galaxy:openStash', function(citizenid)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "MotelDeposu_" .. citizenid, {
        maxweight = 1000000,
        slots = 50,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "MotelDeposu_" .. citizenid)
end)

local function CreateStashTarget()
    exports['qb-target']:AddBoxZone("motel_stash", Config.StashLocation, 1.0, 1.0, {
        name="motel_stash",
        heading=0,
        debugPoly=false,
        minZ=Config.StashLocation.z - 1,
        maxZ=Config.StashLocation.z + 1,
    }, {
        options = {
            {
                type = "client",
                event = "galaxy:requestStash",
                icon = "fas fa-box",
                label = "Kişisel Depo",
            }
        },
        distance = 2.0
    })
end

RegisterNetEvent('galaxy:requestStash')
AddEventHandler('galaxy:requestStash', function()
    TriggerServerEvent('galaxy:getCitizenStash')
end)

local function CreateOutfitTarget()
    exports['qb-target']:AddBoxZone("motel_outfit", Config.OutfitLocation, 1.0, 1.0, {
        name="motel_outfit",
        heading=0,
        debugPoly=false,
        minZ=Config.OutfitLocation.z - 1,
        maxZ=Config.OutfitLocation.z + 1,
    }, {
        options = {
            {
                type = "client",
                event = "illenium-appearance:client:openOutfitMenu",
                icon = "fas fa-tshirt",
                label = "Kıyafet Menüsü",
            }
        },
        distance = 2.0
    })
end

RegisterNetEvent('galaxy:teleportOutside')
AddEventHandler('galaxy:teleportOutside', function()
    PlayDoorAnimation()
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, Config.OutsideLocation.x, Config.OutsideLocation.y, Config.OutsideLocation.z, false, false, false, true)
    SetEntityHeading(playerPed, 164.05)
end)

local function CreateExitTarget()
    exports['qb-target']:AddBoxZone("motel_exit", vector3(346.55, -1013.14, -99.2), 1.0, 1.0, {
        name="motel_exit",
        heading=0,
        debugPoly=false,
        minZ=-99.8,
        maxZ=-98.5,
    }, {
        options = {
            {
                type = "server",
                event = "galaxy:exitRoom",
                icon = "fas fa-door-closed",
                label = "Motelden Çık",
            }
        },
        distance = 2.0
    })
end

CreateThread(function()
    CreateNPC()
    CreateStashTarget()
    CreateOutfitTarget()
    CreateExitTarget()
end)
