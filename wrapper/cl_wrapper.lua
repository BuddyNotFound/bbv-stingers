Wrapper = {
    zone = {},
    blip = {},
}

function Wrapper:Target(id,label,pos,event,_sizex,_sizey) -- QBTarget target create
    if Config.Settings.Target == "QB" then 
        local sizex = _sizex or 1
        local sizey = _sizey or 1
        local _id = id
        exports["qb-target"]:AddBoxZone(_id, pos, sizex, sizey, {
            name = _id,
            heading = '90.0',
            minZ = pos - 5,
            maxZ = pos + 5
        }, {
            options = {
                {
                    type = "client",
                    event = event,
                    icon = "fas fa-button",
                    label = label,
                }
            },
            distance = 1.5
        })
    end
    if Config.Settings.Target == "OX" then 
        local _id = id
        Wrapper.zone[_id] = exports["ox_target"]:addBoxZone({ -- -1183.28, -884.06, 13.75
        coords = vec3(pos.x,pos.y,pos.z),
        size = vec3(1, 1, 1),
        rotation = 45,
        debug = false,
        options = {
            {
                name = _id,
                event = event,
                icon = 'fa-solid fa-cube',
                label = label,
            },
        }
    })
    end
    if Config.Settings.Target == "BT" then 
        local _id = id
        exports['bt-target']:AddBoxZone(_id, vector3(pos.x,pos.y,pos.z), 0.4, 0.6, {
            name=_id,
            heading=91,
            minZ = pos.z - 1,
            maxZ = pos.z + 1
            }, {
                options = {
                    {
                        type = "client",
                        event = event,
                        icon = 'fa-solid fa-cube',
                        label = label,
                    },
                },
                distance = 1.5
            })
    end
    if Config.Settings.Target == "ST" then 
        TriggerEvent('bbv-blacklist:standalone:target',id,label,pos,event)
    end
end

local stwait = 1000

RegisterNetEvent('bbv-blacklist:standalone:target',function(id,label,pos,event)
    while true do 
        Wait(stwait)
        local mypos = GetEntityCoords(PlayerPedId())
        local pedpos = vec3(pos.x,pos.y,pos.z)
        local dist = #(mypos - pedpos)
        if dist < 3 then 
            stwait = 0
            Wrapper:DisplayHelpText('Press [E] to pickup')
            if IsControlJustReleased(0, Config.Settings.InteractKey) then
                Wrapper:Notify(Lang.SpikesPicked)
                TriggerEvent(event)
                return
            end
        else
            stwait = 1000
        end
    end
end)

function Wrapper:DisplayHelpText(txt)
    SetTextComponentFormat("STRING")
    AddTextComponentString(txt)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function Wrapper:TargetRemove(sendid) -- Remove QBTarget target
    if Config.Settings.Target == "QB" then 
    exports["qb-target"]:RemoveZone(sendid)
    end 
    if Config.Settings.Target == "OX" then 
        exports['ox_target']:removeZone(Wrapper.zone[sendid])
    end
    if Config.Settings.Target == "BT" then 
        exports['bt-taget']:RemoveZone(sendid)
    end
end

function Wrapper:RemoveBlip(id)
    RemoveBlip(Wrapper.blip[id])
end

function Wrapper:Blip(id,label,pos,sprite,color,scale) -- Create Normal Blip on Map
    Wrapper.blip[id] = AddBlipForCoord(pos.x, pos.y, pos.z)
    SetBlipSprite (Wrapper.blip[id], sprite)
    SetBlipDisplay(Wrapper.blip[id], 4)
    SetBlipScale  (Wrapper.blip[id], scale)
    SetBlipAsShortRange(Wrapper.blip[id], true)
    SetBlipColour(Wrapper.blip[id], color)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(label)
    EndTextCommandSetBlipName(Wrapper.blip[id])
end

function Wrapper:Notify(txt,tp,time) -- QBCore notify
    if Config.Settings.Framework == "QB" then 
        QBCore.Functions.Notify(txt, tp, time)
    end
    if Config.Settings.Framework == "ESX" then 
        ESX.ShowNotification(txt)
    end
    if Config.Settings.Framework == "ST" then 
        self:Prompt(txt)
    end
end

function Wrapper:Log(webhook,txt) -- Log all of your abusive staff
    TriggerServerEvent('Wrapper:Log',webhook,txt)
end

function Wrapper:RemoveItem(item,amount)
    if Config.Settings.RemoveItem then 
        TriggerServerEvent('Wrapper:RemoveItem', item, amount)
    end
end

function Wrapper:AddItem(item,amount)
    if Config.Settings.ReturnItem then 
        TriggerServerEvent('Wrapper:ReturnItem_stingers', item, amount)
    end
end

function Wrapper:Prompt(msg) --Msg is part of the Text String at B
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg) -- B
	DrawNotification(true, false) -- Look on that website for what these mean, I forget. I think one is about flashing or not
end
