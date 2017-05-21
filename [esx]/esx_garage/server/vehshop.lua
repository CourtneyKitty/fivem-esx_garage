require "resources/[essential]/es_extended/lib/MySQL"
MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "foo")

RegisterServerEvent('vehshop:CheckMoneyForVeh')
AddEventHandler('vehshop:CheckMoneyForVeh', function(vehicle, price)
	
  local _source = source

  TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)
  	if (tonumber(xPlayer.player.money) >= tonumber(price)) then
  			-- Pay the shop (price)
  			xPlayer:removeMoney((price))
        -- Trigger some client stuff
        TriggerClientEvent('FinishMoneyCheckForVeh',_source)
        TriggerClientEvent("esx:showNotification", _source, "Vous avez acheté un véhicule")
      else
        -- Inform the player that he needs more money
      TriggerClientEvent("esx:showNotification", _source, "Vous n'avez pas assez d'argent")
  	end
  end)

end)