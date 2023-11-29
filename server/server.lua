Main = {Spikes = {}}
DiscordWebHook = '' -- used for logs

RegisterNetEvent('bbv-spikes:sync:server',function(CurrentCoords,heading)
    Main.Spikes[#Main.Spikes + 1] = CreateObjectNoOffset(Config.Settings.SpikeModel, CurrentCoords.x, CurrentCoords.y, CurrentCoords.z, true, true, false)
    SetEntityHeading(Main.Spikes[#Main.Spikes] , heading)
    FreezeEntityPosition(Main.Spikes[#Main.Spikes] , true)
    TriggerClientEvent('bbv-spikes:sync:client', -1, Main, NetworkGetNetworkIdFromEntity(Main.Spikes[#Main.Spikes]), CurrentCoords)
end)

RegisterNetEvent('bbv-spikes:server:remove',function(id)
    DeleteEntity(NetworkGetEntityFromNetworkId(id))
    Main.Spikes[id] = nil

    TriggerClientEvent('bbv-spikes:sync:cl', -1, Main, id)
end)

if Config.Settings.Framework == "QB" then 
    QBCore.Functions.CreateUseableItem(Config.Settings.ItemName, function(source, item)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        if Player.Functions.GetItemByName(item.name) then
            TriggerEvent('Wrapper:Log',src,DiscordWebHook,'Used Spikes')
            TriggerClientEvent('bbv-spikes:spike',src)
        end
    end)
end

if Config.Settings.Framework == "ESX" then 
    ESX.RegisterUsableItem(Config.Settings.ItemName, function(source)
        local src = source
        TriggerEvent('Wrapper:Log',src,DiscordWebHook,'Used Spikes')
        TriggerClientEvent('bbv-spikes:spike',src)
    end)
end

if Config.Settings.Framework == "ST" then 
    RegisterCommand(Config.Settings.ItemName, function(source)
        local src = source
        TriggerEvent('Wrapper:Log',src,DiscordWebHook,'Used Spikes')
        TriggerClientEvent('bbv-spikes:spike',src)
    end)
end
