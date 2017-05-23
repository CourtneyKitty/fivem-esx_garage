local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local GUI                          = {}
GUI.Time                           = 0
local hasAlreadyEnteredMarker      = false;
local lastZone                     = nil;
local PlayerData                   = nil
local LastVehicle                  = nil;
local HasLoadedParking             = false
local IsInGarage                   = false
local IsInExteriorGarageSpawnPoint = false
local Message                      = nil

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function GetVehicleProperties(vehicle)

	local colour1, colour2             = GetVehicleColours(vehicle)
	local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
	
	return {
		
		model            = GetEntityModel(vehicle),
		
		plate            = GetVehicleNumberPlateText(vehicle),
		plateIndex       = GetVehicleNumberPlateTextIndex(vehicle),

		color1           = colour1,
		color2           = colour2,
		pearlescentColor = pearlescentColor,
		wheelColor       = wheelColor,
		
		wheels           = GetVehicleWheelType(vehicle),
		windowTint       = GetVehicleWindowTint(vehicle),
		
		neonColor        = table.pack(GetVehicleNeonLightsColour(vehicle)),
		
		modSpoilers      = GetVehicleMod(vehicle, 0),
		modFrontBumper   = GetVehicleMod(vehicle, 1),
		modRearBumper    = GetVehicleMod(vehicle, 2),
		modSideSkirt     = GetVehicleMod(vehicle, 3),
		modExhaust       = GetVehicleMod(vehicle, 4),
		modFrame         = GetVehicleMod(vehicle, 5),
		modGrille        = GetVehicleMod(vehicle, 6),
		modHood          = GetVehicleMod(vehicle, 7),
		modFender        = GetVehicleMod(vehicle, 8),
		modRightFender   = GetVehicleMod(vehicle, 9),
		modRoof          = GetVehicleMod(vehicle, 10),

		modEngine        = GetVehicleMod(vehicle, 11),
		modBrakes        = GetVehicleMod(vehicle, 12),
		modTransmission  = GetVehicleMod(vehicle, 13),
		modHorns         = GetVehicleMod(vehicle, 14),
		modSuspension    = GetVehicleMod(vehicle, 15),
		modArmor         = GetVehicleMod(vehicle, 16),

		modTurbo         = IsToggleModOn(vehicle,  18),
		modXenon         = IsToggleModOn(vehicle,  22),

		modFrontWheels   = GetVehicleMod(vehicle, 23),
		modBackWheels    = GetVehicleMod(vehicle, 24)
	}

end

function SetVehicleProperties(vehicle, props)

	SetVehicleModKit(vehicle,  0)

	if props.plate ~= nil then
		SetVehicleNumberPlateText(vehicle,  props.plate)
	end

	if props.plateIndex ~= nil then
		SetVehicleNumberPlateTextIndex(vehicle,  props.plateIndex)
	end

	if props.color1 ~= nil and props.color2 ~= nil then
		SetVehicleColours(vehicle, props.color1, props.color2)
	end

	if props.pearlescentColor ~= nil and props.wheelColor ~= nil then
		SetVehicleExtraColours(vehicle,  props.pearlescentColor,  props.wheelColor)
	end

	if props.wheels ~= nil then
		SetVehicleWheelType(vehicle,  props.wheels)
	end

	if props.windowTint ~= nil then
		SetVehicleWindowTint(vehicle,  props.windowTint)
	end

	if props.neonColor ~= nil then
		SetVehicleNeonLightsColour(vehicle,  props.neonColor[1], props.neonColor[2], props.neonColor[3])
	end

	if props.modSpoilers ~= nil then
		SetVehicleMod(vehicle, 0, props.modSpoilers, false)
	end

	if props.modFrontBumper ~= nil then
		SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
	end

	if props.modRearBumper ~= nil then
		SetVehicleMod(vehicle, 2, props.modRearBumper, false)
	end

	if props.modSideSkirt ~= nil then
		SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
	end

	if props.modExhaust ~= nil then
		SetVehicleMod(vehicle, 4, props.modExhaust, false)
	end

	if props.modFrame ~= nil then
		SetVehicleMod(vehicle, 5, props.modFrame, false)
	end

	if props.modGrille ~= nil then
		SetVehicleMod(vehicle, 6, props.modGrille, false)
	end

	if props.modHood ~= nil then
		SetVehicleMod(vehicle, 7, props.modHood, false)
	end

	if props.modFender ~= nil then
		SetVehicleMod(vehicle, 8, props.modFender, false)
	end

	if props.modRightFender ~= nil then
		SetVehicleMod(vehicle, 9, props.modRightFender, false)
	end

	if props.modRoof ~= nil then
		SetVehicleMod(vehicle, 10, props.modRoof, false)
	end

	if props.modEngine ~= nil then
		SetVehicleMod(vehicle, 11, props.modEngine, false)
	end

	if props.modBrakes ~= nil then
		SetVehicleMod(vehicle, 12, props.modBrakes, false)
	end

	if props.modTransmission ~= nil then
		SetVehicleMod(vehicle, 13, props.modTransmission, false)
	end

	if props.modHorns ~= nil then
		SetVehicleMod(vehicle, 14, props.modHorns, false)
	end

	if props.modSuspension ~= nil then
		SetVehicleMod(vehicle, 15, props.modSuspension, false)
	end

	if props.modArmor ~= nil then
		SetVehicleMod(vehicle, 16, props.modArmor, false)
	end

	if props.modTurbo ~= nil then
		ToggleVehicleMod(vehicle,  18, props.modTurbo)
	end

	if props.modXenon ~= nil then
		ToggleVehicleMod(vehicle,  22, props.modXenon)
	end

	if props.modFrontWheels ~= nil then
		SetVehicleMod(vehicle, 23, props.modFrontWheels, false)
	end

	if props.modBackWheels ~= nil then
		SetVehicleMod(vehicle, 24, props.modBackWheels, false)
	end

end

AddEventHandler('esx_garage:hasEnteredMarker', function(zone)

	for k,v in pairs(Config.Parkings) do

		if zone == k then

			local playerPed = GetPlayerPed(-1)

			if IsPedInAnyVehicle(playerPed, false) then

				local vehicle     = GetVehiclePedIsIn(playerPed, false)
				local vehicleData = GetVehicleProperties(vehicle)

				for i=1, #PlayerData.parking, 1 do
					if PlayerData.parking[i].zone == zone then

						for j=1, #PlayerData.ownedVehicles, 1 do
							if PlayerData.ownedVehicles[j] == vehicleData.plate then
								vehicleData.owner = PlayerData.identifier
							end
						end

						PlayerData.parking[i].vehicle = vehicleData

					end
				end

				TriggerServerEvent('esx_garage:addedParkedVehicle', zone, vehicleData)
				TriggerEvent('esx:showNotification', 'Véhicule garé')
				break

			end
		end

	end

	if zone == 'ExteriorGarageEntryPoint' then

		local playerPed = GetPlayerPed(-1)

		if IsPedInAnyVehicle(playerPed,  false) then

			local vehicle = GetVehiclePedIsIn(playerPed, false)
			
			if GetPedInVehicleSeat(vehicle,  -1) == playerPed then
				LastVehicle = GetVehicleProperties(vehicle)
			end

			SetEntityCoords(playerPed, Config.Zones.InteriorGarageSpawnPoint.Pos.x, Config.Zones.InteriorGarageSpawnPoint.Pos.y, Config.Zones.InteriorGarageSpawnPoint.Pos.z)
			DeleteVehicle(vehicle)

		else

			SetEntityCoords(playerPed, Config.Zones.InteriorGarageSpawnPoint.Pos.x, Config.Zones.InteriorGarageSpawnPoint.Pos.y, Config.Zones.InteriorGarageSpawnPoint.Pos.z)

		end

	end

	if zone == 'InteriorGarageSpawnPoint' then

			IsInGarage = true

			local playerPed = GetPlayerPed(-1)

			if LastVehicle ~= nil then

				local model = LastVehicle.model
				
				Citizen.CreateThread(function()

					RequestModel(model)
					
					while not HasModelLoaded(model) do
						Citizen.Wait(0)
					end

					local vehicle = CreateVehicle(model, Config.Zones.InteriorGarageSpawnPoint.Pos.x, Config.Zones.InteriorGarageSpawnPoint.Pos.y, Config.Zones.InteriorGarageSpawnPoint.Pos.z + Config.ParkingZDiff,  0.0,  false,  false)
					
					SetModelAsNoLongerNeeded(model)
					-- SetVehicleOnGroundProperly(vehicle)
					TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
					
					SetVehicleProperties(vehicle, LastVehicle)

					LastVehicle = nil

				end)

			end

			if not HasLoadedParking then

				Citizen.CreateThread(function()

					for i=1, #PlayerData.parking, 1 do

						if PlayerData.parking[i].vehicle.plate ~= nil then

							local zone        = PlayerData.parking[i].zone;
							local vehicleData = PlayerData.parking[i].vehicle
							local model       = vehicleData.model

							RequestModel(model)
							
							while not HasModelLoaded(model) do
								Citizen.Wait(0)
							end

							local vehicle = CreateVehicle(model, Config.Zones[zone].Pos.x, Config.Zones[zone].Pos.y, Config.Zones[zone].Pos.z + Config.ParkingZDiff, Config.Zones[zone].heading,  false,  false)

							SetModelAsNoLongerNeeded(model)
							SetVehicleOnGroundProperly(vehicle)
							
							SetVehicleProperties(vehicle, vehicleData)

						end

					end

				end)

				HasLoadedParking = true

			end

	end

	if zone == 'InteriorGarageExitPoint' then

		local playerPed = GetPlayerPed(-1)

		if IsPedInAnyVehicle(playerPed,  false) then

			local vehicle = GetVehiclePedIsIn(playerPed, false)
			LastVehicle   = GetVehicleProperties(vehicle)

			SetEntityCoords(playerPed, Config.Zones.ExteriorGarageSpawnPoint.Pos.x, Config.Zones.ExteriorGarageSpawnPoint.Pos.y, Config.Zones.ExteriorGarageSpawnPoint.Pos.z)
			DeleteVehicle(vehicle)

		else

			SetEntityCoords(playerPed, Config.Zones.ExteriorGarageSpawnPoint.Pos.x, Config.Zones.ExteriorGarageSpawnPoint.Pos.y, Config.Zones.ExteriorGarageSpawnPoint.Pos.z)

		end

		for k,v in pairs(Config.Parkings) do
			if IsAnyVehicleNearPoint(v.Pos.x, v.Pos.y, v.Pos.z, 4.0) then
				local vehicle = GetClosestVehicle(v.Pos.x, v.Pos.y, v.Pos.z, 4.0,  0,  71)
				DeleteVehicle(vehicle)
			end
		end

		HasLoadedParking = false

	end

	if zone == 'ExteriorGarageSpawnPoint' then

			IsInGarage                   = false
			IsInExteriorGarageSpawnPoint = true

			local playerPed = GetPlayerPed(-1)

			if LastVehicle ~= nil then

				local playerPed = GetPlayerPed(-1)
				local model     = LastVehicle.model
				
				Citizen.CreateThread(function()

					RequestModel(model)
					
					while not HasModelLoaded(model) do
						Citizen.Wait(0)
					end

					local vehicle = CreateVehicle(model, Config.Zones.ExteriorGarageSpawnPoint.Pos.x, Config.Zones.ExteriorGarageSpawnPoint.Pos.y, Config.Zones.ExteriorGarageSpawnPoint.Pos.z,  180.0,  true,  false)

				  SetModelAsNoLongerNeeded(model)
					SetVehicleOnGroundProperly(vehicle)

					TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)

					SetVehicleHasBeenOwnedByPlayer(vehicle,  true)
					SetEntityAsMissionEntity(vehicle,  true,  true)
					local id = NetworkGetNetworkIdFromEntity(vehicle)
					SetNetworkIdCanMigrate(id, true)
					
					SetVehicleProperties(vehicle, LastVehicle)

					TriggerServerEvent('esx_garage:setLastVehicle', LastVehicle)

					LastVehicle = nil
				end)

			end

	end

	if zone == 'Resell' then

		if IsAnyVehicleNearPoint(Config.Zones.Resell.Pos.x,  Config.Zones.Resell.Pos.y,  Config.Zones.Resell.Pos.z,  5.0) then
			TriggerEvent('esx:showNotification', 'Sortez de votre véhicule et appuyez sur ENTREE pour le vendre à ' .. Config.ResellPercentage .. '% de son prix d\'origine')
		end

	end

end)

AddEventHandler('esx_garage:hasExitedMarker', function(zone)
	
	for k,v in pairs(Config.Parkings) do

		if zone == k then

			local playerPed = GetPlayerPed(-1)

			if IsPedInAnyVehicle(playerPed, false) then

				for i=1, #PlayerData.parking, 1 do

					local parking = PlayerData.parking[i]

					if parking.zone == zone then
						PlayerData.parking[i].vehicle = {}
						break
					end
				end

				TriggerServerEvent('esx_garage:removedParkedVehicle', k)
				TriggerEvent('esx:showNotification', 'Véhicule sorti')
			end
		end

	end

	if zone == 'ExteriorGarageSpawnPoint' then
		IsInExteriorGarageSpawnPoint = false
	end

end)

RegisterNetEvent('esx_garage:onPlayerData')
AddEventHandler('esx_garage:onPlayerData', function(playerData)
	PlayerData = playerData
end)

RegisterNetEvent('esx_garage:requestSaveVehicle')
AddEventHandler('esx_garage:requestSaveVehicle', function()

	local playerPed = GetPlayerPed(-1)

	if IsPedInAnyVehicle(playerPed,  true) then
		
		local vehicle     = GetVehiclePedIsIn(playerPed, false)
		local vehicleData = GetVehicleProperties(vehicle)

		TriggerServerEvent('esx_garage:responseSaveVehicle', vehicleData)

	else
		TriggerEvent('esx:showNotification', 'Vous devez être dans un véhicule')
	end

end)

RegisterNetEvent('esx_garage:spawnVehicle')
AddEventHandler('esx_garage:spawnVehicle', function(vehicleData)

	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)
	local heading   = GetEntityHeading(playerPed)
	local model     = vehicleData.model

	Citizen.CreateThread(function()

		RequestModel(model)
		
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z,  heading,  true,  false)

	  SetModelAsNoLongerNeeded(model)
		SetVehicleOnGroundProperly(vehicle)

		TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)

		SetVehicleHasBeenOwnedByPlayer(vehicle,  true)
		SetEntityAsMissionEntity(vehicle,  true,  true)
		local id = NetworkGetNetworkIdFromEntity(vehicle)
		SetNetworkIdCanMigrate(id, true)
		
		SetVehicleProperties(vehicle, vehicleData)
	end)

end)

RegisterNetEvent('esx_garage:responseResell')
AddEventHandler('esx_garage:responseResell', function(success)

	if success then

		local playerPed = GetPlayerPed(-1)

		if IsAnyVehicleNearPoint(Config.Zones.Resell.Pos.x,  Config.Zones.Resell.Pos.y,  Config.Zones.Resell.Pos.z,  5.0) and not IsPedInAnyVehicle(playerPed,  false) then
			local vehicle = GetClosestVehicle(Config.Zones.Resell.Pos.x,  Config.Zones.Resell.Pos.y,  Config.Zones.Resell.Pos.z,  5.0,  0,  71)
			DeleteVehicle(vehicle)
			TriggerEvent('esx:showNotification', 'Véhicule vendu')
		end

	else
		TriggerEvent('esx:showNotification', 'Ce n\'est pas votre véhicule')
	end

end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		
		Wait(0)
		
		local coords = GetEntityCoords(GetPlayerPed(-1))
		
		for k,v in pairs(Config.Zones) do

			if Config.Parkings[k] ~= nil then

				local playerPed   = GetPlayerPed(-1)

				if(IsPedInAnyVehicle(playerPed,  false) and v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				end

			else

				if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				end

			end

		end
	end
end)

-- Marker interactions
Citizen.CreateThread(function()
	while true do
		
		Wait(0)
		
		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x / 2) then
				isInMarker  = true
				currentZone = k
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			lastZone                = currentZone
			TriggerEvent('esx_garage:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker or (isInMarker and currentZone ~= lastZone) then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_garage:hasExitedMarker', lastZone)
		end

	end
end)

-- Create blips
Citizen.CreateThread(function()

	local blip = AddBlipForCoord(Config.Zones.ExteriorGarageEntryPoint.Pos.x, Config.Zones.ExteriorGarageEntryPoint.Pos.y, Config.Zones.ExteriorGarageEntryPoint.Pos.z)
  
  SetBlipSprite (blip, 357)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 1.2)
  SetBlipColour (blip, 3)
  SetBlipAsShortRange(blip, true)
	
	BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Garage")
  EndTextCommandSetBlipName(blip)

	local blip = AddBlipForCoord(Config.Zones.Resell.Pos.x, Config.Zones.Resell.Pos.y, Config.Zones.Resell.Pos.z)
  
  SetBlipSprite (blip, 207)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 1.2)
  SetBlipColour (blip, 3)
  SetBlipAsShortRange(blip, true)
	
	BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Revente")
  EndTextCommandSetBlipName(blip)


end)

-- Hide other players in garage / No collide in ExteriorGarageSpawnPoint
Citizen.CreateThread(function()

	while true do

		Wait(0)

		local playerPed = GetPlayerPed(-1)

		if IsInGarage then

			for i=0, 32, 1 do
				if i ~= PlayerId() then
					local otherPlayerPed = GetPlayerPed(i)
					SetEntityLocallyInvisible(otherPlayerPed)
					SetEntityNoCollisionEntity(playerPed,  otherPlayerPed,  true)
				end
			end

		end

		if IsInExteriorGarageSpawnPoint then

			for i=0, 32, 1 do
				if i ~= PlayerId() then
					local otherPlayerPed = GetPlayerPed(i)
					SetEntityNoCollisionEntity(playerPed,  otherPlayerPed,  true)
				end
			end

			if IsPedInAnyVehicle(playerPed,  true) then

				local vehicle = GetVehiclePedIsIn(playerPed,  true)
				
				for i=0, 32, 1 do
					if i ~= PlayerId() then

						local otherPlayerPed = GetPlayerPed(i)

						if IsPedInAnyVehicle(otherPlayerPed,  true) then
							local otherPlayerVehicle = GetVehiclePedIsIn(otherPlayerPed,  true)
							SetEntityNoCollisionEntity(playerPed,  otherPlayerVehicle,  true)
							SetEntityNoCollisionEntity(vehicle,    otherPlayerVehicle,  true)
						end
					end

				end

			end

		end

	end

end)

Citizen.CreateThread(function()

	while true do

		Wait(0)

		if lastZone == 'Resell' and IsControlPressed(0,  Keys['ENTER']) and (GetGameTimer() - GUI.Time) > 500 then

			local playerPed = GetPlayerPed(-1)

			if IsAnyVehicleNearPoint(Config.Zones.Resell.Pos.x,  Config.Zones.Resell.Pos.y,  Config.Zones.Resell.Pos.z,  5.0) and not IsPedInAnyVehicle(playerPed,  false) then

				local vehicle = GetClosestVehicle(Config.Zones.Resell.Pos.x,  Config.Zones.Resell.Pos.y,  Config.Zones.Resell.Pos.z,  5.0,  0,  71)
				local model   = GetEntityModel(vehicle)

				TriggerEvent('vehshop:getVehicleCost', model, function(cost)
					
					if cost == -1 then
						TriggerEvent('esx:showNotification', 'Ce véhicule n\'est pas dans le catalogue')
					else
						local percentCost = round(cost / 100 * Config.ResellPercentage, 0)
						TriggerServerEvent('esx_garage:requestResell', GetVehicleNumberPlateText(vehicle), percentCost)
					end

				end)

			end

			GUI.Time = GetGameTimer()

		end

	end

end)