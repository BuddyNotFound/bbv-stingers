Wrapper = {}



RegisterNetEvent("Wrapper:Log",function(_src,webhook,txt)
    local src = _src
    local name = GetPlayerName(src)
    local steam = GetPlayerIdentifier(src)
    local ip = GetPlayerEndpoint(src)
    local identifiers = Wrapper:Identifiers(src)
    local license = identifiers.license
    local discord ="<@" ..identifiers.discord:gsub("discord:", "")..">" 
    local disconnect = {
            {
                ["color"] = "16711680", -- Color in decimal
                ["title"] = txt, -- Title of the embed message
                ["description"] = "Name: **"..name.."**\nSteam ID: **"..steam.."**\nIP: **" .. ip .."**\nGTA License: **" .. license .. "**\nDiscord Tag: **" .. discord .. "**\nLog: **"..txt.."**", -- Main Body of embed with the info about the person who left
            }
        }
    
        PerformHttpRequest(Config.Settings.Webhook, function(err, text, headers) end, 'POST', json.encode({username = username, embeds = disconnect, tts = TTS}), { ['Content-Type'] = 'application/json' }) -- Perform the request to the discord webhook and send the specified message
end)

function Wrapper:Identifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end

RegisterNetEvent("Wrapper:ReturnItem",function(item,amount)
    local src = source
    TriggerEvent('Wrapper:Log',src,Config.Settings.Webhook,'Picked Spikes')
    Wrapper:AddItemServer(item,amount)
end)


function Wrapper:AddItemServer(item,amount)
    if Config.Settings.Framework == "QB" then 
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        if not Player then return end
        Player.Functions.AddItem(item, amount) 
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add")
    end
    if Config.Settings.Framework == "QBX" then 
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        if not Player then return end
        Player.Functions.AddItem(item, amount) 
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add")
    end
    if Config.Settings.Framework == "ESX" then 
        local src = source 
        local xPlayer = ESX.GetPlayerFromId(src)
        xPlayer.addInventoryItem(item, amount)
    end
end

RegisterNetEvent("Wrapper:RemoveItem",function(item,amount)
    Wrapper:RemoveItemServer(item,amount)
end)

function Wrapper:RemoveItemServer(item,amount)
    if Config.Settings.Framework == "QB" then 
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        if not Player then return end
        Player.Functions.RemoveItem(item, amount) 
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove")
    end
    if Config.Settings.Framework == "QBX" then 
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        if not Player then return end
        Player.Functions.RemoveItem(item, amount) 
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove")
    end
    if Config.Settings.Framework == "ESX" then 
        local src = source 
        local xPlayer = ESX.GetPlayerFromId(src)
        xPlayer.removeInventoryItem(item, amount)
    end
end
