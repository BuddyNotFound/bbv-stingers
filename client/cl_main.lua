Main = { 
    data = {},
    model = 'p_ld_stinger_s'
}
Spike = {}

RegisterNetEvent('bbv-spikes:spike',function()
    Main:PlaceSpike()
end)

function Main:PlaceSpike()
    if PlacingObject then Wrapper:Notify(Lang.DoingSomething) return end
	PlacingObject = true
	object = Main.model
    CurrentSpawnRange = 15
    
    self:RequestSpawnObject(object)
    CurrentModel = object
    CurrentObject = CreateObject(object, 1.0, 1.0, 1.0, false, true, false)
    heading = 0.0
    SetEntityHeading(CurrentObject, 0)
    
    SetEntityAlpha(CurrentObject, 150)
    SetEntityDrawOutline(CurrentObject,true)
    SetEntityDrawOutlineColor(1,188,255,255)
    SetEntityCollision(CurrentObject, false, false)
    FreezeEntityPosition(CurrentObject, true)

    CreateThread(function()
        form = self:setupScaleform("instructional_buttons")
        while PlacingObject do
            local hit, coords, entity = self:RayCastGamePlayCamera(20.0)
            CurrentCoords = coords

            DrawScaleformMovieFullscreen(form, 255, 255, 255, 255, 0)

            if hit then
                SetEntityCoords(CurrentObject, coords.x, coords.y, coords.z)
            end
            
            if IsControlJustPressed(0, 174) then
                heading = heading + 5
                if heading > 360 then heading = 0.0 end
            end
    
            if IsControlJustPressed(0, 175) then
                heading = heading - 5
                if heading < 0 then heading = 360.0 end
            end
            
            if IsControlJustPressed(0, 44) then
                self:CancelPlacement(CurrentObject)
            end 

            SetEntityHeading(CurrentObject, heading)
            if IsControlJustPressed(0, 38) then
                Wait(100)
                Wrapper:RemoveItem(Config.Settings.ItemName, 1)
                Wrapper:Notify(Lang.SpikesPlaced)
                TriggerServerEvent('bbv-spikes:sync:server',CurrentCoords,heading)
                self:CancelPlacement(CurrentObject)
            end
            Wait(1)
        end
    end)
end

RegisterNetEvent('bbv-spikes:sync:cl',function(data, id)
    Spike = data
    Wrapper:TargetRemove('Spike'..id)
end)

RegisterNetEvent('bbv-spikes:sync:client',function(data,id,pos)
    Spike = data
    local SpikeProp = id
    Spike = {
        position = pos
    }
    Wrapper:Blip(SpikeProp,'Spike Strip',pos,Config.Settings.Blips.Sprite,Config.Settings.Blips.Color,Config.Settings.Blips.Scale)
    Wrapper:Target('Spike'..SpikeProp, 'Pick Up',  pos ,'removeprop:Spike'..SpikeProp, 1.5 , 1.5)
    RegisterNetEvent('removeprop:Spike'..SpikeProp,function()
        local player = PlayerId()
        local plyPed = GetPlayerPed(player)
        local plyPos = GetEntityCoords(plyPed, false)
        Wrapper:Notify(Lang.SpikesPicked)
        ExecuteCommand('e pickup')
        Wrapper:RemoveBlip(SpikeProp)
        Wrapper:AddItem(Config.Settings.ItemName,1)
        TriggerServerEvent('bbv-spikes:server:remove', SpikeProp)
    end)
end)

function Main:RequestSpawnObject(object)
    local hash = GetHashKey(object)
    RequestModel(hash)
    while not HasModelLoaded(hash) do 
        Wait(1000)
    end
end

function Main:setupScaleform(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 0, 0)

    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()


    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    self:Button(GetControlInstructionalButton(2, 152, true))
    self:ButtonMessage(Lang.Cancel)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    self:Button(GetControlInstructionalButton(2, 153, true))
    self:ButtonMessage(Lang.PlaceObject)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    self:Button(GetControlInstructionalButton(2, 190, true))
    self:Button(GetControlInstructionalButton(2, 189, true))
    self:ButtonMessage(Lang.RotateObject)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

CheckTime = 2000
local tires = {
    {bone = "wheel_lf", index = 0},
    {bone = "wheel_rf", index = 1},
    {bone = "wheel_lm", index = 2},
    {bone = "wheel_rm", index = 3},
    {bone = "wheel_lr", index = 4},
    {bone = "wheel_rr", index = 5},
}

function Main:ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function Main:Button(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end


function Main:RotationToDirection(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

function Main:RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = self:RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestSweptSphere(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, 0.2, 339, PlayerPedId(), 4))
	return b, c, e
end

function Main:CancelPlacement(CurrentObject)
    SetEntityDrawOutline(CurrentObject,false)
    DeleteObject(CurrentObject)
    cd = true
    PlacingObject = false
    CurrentObject = nil
    CurrentObjectType = nil
    CurrentObjectName = nil
    CurrentSpawnRange = nil
    CurrentCoords = nil
end

CreateThread(function()
    while true do
        Wait(CheckTime)
        if IsPedInAnyVehicle(PlayerPedId(), true) then
            local closestSpike = Main:GetClosestSpike()
            local vehicle = GetVehiclePedIsIn(PlayerPedId())
            CheckTime = 0
            if closestSpike ~= nil and closestSpike.sdist < 10 then 
                for a = 1, #tires do
                    local tirePos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tires[a].bone))
                    if closestSpike.sdist < 1.8 then
                        if not IsVehicleTyreBurst(vehicle, tires[a].index, true) or IsVehicleTyreBurst(vehicle, tires[a].index, false) then
                            SetVehicleTyreBurst(vehicle, tires[a].index, false, 1000.0)
                        end
                    end
                end
            end
        else
            CheckTime = 2000
        end
    end
end)

function Main:GetClosestSpike()
    local closestSpike = nil
    local minDistance = math.huge

    for k, v in pairs(Spike) do 
        local ped = PlayerPedId()
        local mypos = GetEntityCoords(ped)
        local spikepos = vec3(v.x,v.y,v.z)
        local dist = #(mypos - spikepos)

        if dist < minDistance then
            minDistance = dist
            closestSpike = {spos = spikepos, sdist = dist}
        end
    end

    return closestSpike
end
