-- One each game tick --
function onTick(event)
    for k, player in pairs(game.players) do
        if event.tick%60 == 0 then GUI.updateGUI(player) end
    end
end

-- Update all values --
function updateValues()
    if global.playersTable == nil then global.playersTable = {} end
    if global.teamTable == nil then global.teamTable = {} end
end