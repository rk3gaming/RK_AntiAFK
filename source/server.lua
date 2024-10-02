RegisterServerEvent("LSC:AntiAFK:kick")
AddEventHandler("LSC:AntiAFK:kick", function()
    local playerName = GetPlayerName(source) 
    TriggerClientEvent('chat:addMessage', -1, {
        color = {255, 99, 71},
        multiline = true,
        args = {"AFK System", playerName .. " has been kicked for being AFK."}
    })

    DropPlayer(source, "You have been kicked for being AFK.")
end)
