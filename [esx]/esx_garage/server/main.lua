require "resources/[essential]/es_extended/lib/MySQL"
MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "foo")

AddEventHandler('esx:playerLoaded', function(source)

	local _source = source

	TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

		local parking       = {}
		local ownedVehicles = {}

		local executed_query = MySQL:executeQuery("SELECT * FROM user_parkings WHERE identifier = '@identifier'", {['@identifier'] = xPlayer.identifier})
		local result         = MySQL:getResults(executed_query, {'zone', 'vehicle'})

		local foundZones = {}

		for i=1, #result, 1 do
			
			foundZones[result[i].zone] = true
			
			local vehicle = json.decode(result[i].vehicle)

			table.insert(parking, {
				zone    = result[i].zone,
				vehicle = vehicle
			})

			if vehicle.plate ~= nil and vehicle.owner == xPlayer.identifier then
				table.insert(ownedVehicles, vehicle.plate)
			end

		end

		for k,v in pairs(Config.Parkings) do
			if foundZones[k] == nil then
				
				MySQL:executeQuery("INSERT INTO user_parkings (identifier, zone, vehicle) VALUES ('@identifier', '@zone', '{}')", {['@identifier'] = xPlayer.identifier, ['@zone'] = k})
			
				table.insert(parking, {
					zone    = k,
					vehicle = {}
				})

			end
		end

		xPlayer['parking']       = parking
		xPlayer['ownedVehicles'] = ownedVehicles

		TriggerClientEvent('esx_garage:onPlayerData', _source, {
			identifier    = xPlayer.identifier,
			parking       = xPlayer.parking,
			ownedVehicles = xPlayer.ownedVehicles
		})

	end)
end)

RegisterServerEvent('esx_garage:removedParkedVehicle')
AddEventHandler('esx_garage:removedParkedVehicle', function(zone)
	
	TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

		for i=1, #xPlayer.parking, 1 do

			local parking = xPlayer.parking[i]

			if parking.zone == zone then
				xPlayer.parking[i].vehicle = {}
				break
			end

		end

		MySQL:executeQuery("UPDATE user_parkings SET vehicle = '{}' WHERE identifier = '@identifier' AND zone = '@zone'", {['@identifier'] = xPlayer.identifier, ['@zone'] = zone})

	end)

end)

RegisterServerEvent('esx_garage:addedParkedVehicle')
AddEventHandler('esx_garage:addedParkedVehicle', function(zone, vehicleData)
	
	TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

		for i=1, #xPlayer.parking, 1 do
			if xPlayer.parking[i].zone == zone then
				xPlayer.parking[i].vehicle = vehicleData
			end
		end

		MySQL:executeQuery("UPDATE user_parkings SET vehicle = '@vehicle' WHERE identifier = '@identifier' AND zone = '@zone'", {['@identifier'] = xPlayer.identifier, ['@zone'] = zone, ['@vehicle'] = json.encode(vehicleData)})

	end)

end)

RegisterServerEvent('esx_garage:setCarOwned')
AddEventHandler('esx_garage:setCarOwned', function(plate)

  local _source = source

  TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)
    
    table.insert(xPlayer.ownedVehicles, plate)

		TriggerClientEvent('esx_garage:onPlayerData', _source, {
			identifier    = xPlayer.identifier,
			parking       = xPlayer.parking,
			ownedVehicles = xPlayer.ownedVehicles
		})

  end)

end)


RegisterServerEvent('esx_garage:setLastVehicle')
AddEventHandler('esx_garage:setLastVehicle', function(vehicleData)
  TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)
		MySQL:executeQuery("UPDATE users SET last_vehicle = '@last_vehicle' WHERE identifier = '@identifier'", {['@identifier'] = xPlayer.identifier, ['@last_vehicle'] = json.encode(vehicleData)})
  end)
end)

-- Save vehicle data
TriggerEvent('es:addGroupCommand', 'savevehicle', "admin", function(source, args, user)
	TriggerClientEvent('esx_garage:requestSaveVehicle', source)
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient Permissions.")
end)

RegisterServerEvent('esx_garage:responseSaveVehicle')
AddEventHandler('esx_garage:responseSaveVehicle', function(vehicleData)
	
	local file = io.open('resources/[esx]/esx_garage/vehicles.txt', "a")

	file:write(json.encode(vehicleData) .. "\n")
	file:flush()
	file:close()
end)

RegisterServerEvent('esx_garage:requestResell')
AddEventHandler('esx_garage:requestResell', function(plate, cost)

	local _source = source

	TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

		for i=1, #xPlayer.ownedVehicles, 1 do
			if xPlayer.ownedVehicles[i] == plate then
				xPlayer:addMoney(cost)
				TriggerClientEvent('esx_garage:responseResell', _source, true)
				return
			end
		end

		TriggerClientEvent('esx_garage:responseResell', _source, false)

	end)

end)


-- Spawn last vehicle
TriggerEvent('es:addCommand', 'pv', function(source, args, user)

	local executed_query = MySQL:executeQuery("SELECT * FROM users WHERE identifier = '@identifier'", {['@identifier'] = user.identifier})
	local result         = MySQL:getResults(executed_query, {'last_vehicle'})

	local vehicleData = {}

	if result[1].last_vehicle ~= nil then
		vehicleData = json.decode(result[1].last_vehicle)
	end
	
	if vehicleData.plate ~= nil then
		TriggerClientEvent('esx_garage:spawnVehicle', source, vehicleData)
	end

end)