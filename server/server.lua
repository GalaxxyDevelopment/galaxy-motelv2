local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent("galaxy:checkRoom")
AddEventHandler("galaxy:checkRoom", function()
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local PlayerCitizenID = xPlayer.PlayerData.citizenid

    MySQL.scalar('SELECT motel_room FROM players WHERE citizenid = ?', {PlayerCitizenID}, function(room)
        if room then
            TriggerEvent("galaxy:enterRoom", src, room)
        else
            local newRoom = math.random(1, 1000)
            MySQL.update('UPDATE players SET motel_room = ? WHERE citizenid = ?', {newRoom, PlayerCitizenID}, function()
                TriggerEvent("galaxy:enterRoom", src, newRoom)
            end)
        end
    end)
end)

RegisterServerEvent("galaxy:enterRoom")
AddEventHandler("galaxy:enterRoom", function(src, room)
    SetPlayerRoutingBucket(src, src)
    TriggerClientEvent("galaxy:teleportPlayer", src, room)
end)

RegisterServerEvent('galaxy:getCitizenStash')
AddEventHandler('galaxy:getCitizenStash', function()
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local citizenid = xPlayer.PlayerData.citizenid
    TriggerClientEvent('galaxy:openStash', src, citizenid)
end)

RegisterServerEvent('galaxy:exitRoom')
AddEventHandler('galaxy:exitRoom', function()
    local src = source
    SetPlayerRoutingBucket(src, 0)
    TriggerClientEvent("galaxy:teleportOutside", src)
end)

local correctScriptName = "galaxy-motelv2"

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        if resourceName ~= correctScriptName then
            print(string.format("^1HATA: Bu scriptin adını değiştiremezsiniz! Doğru ad: '%s'^7", correctScriptName))
            os.exit()
        else
            print(string.format("^2Başarı: Script adı doğru, '%s' adıyla başlatılıyor.^7", correctScriptName))
        end
    end
end)
