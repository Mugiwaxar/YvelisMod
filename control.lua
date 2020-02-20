if script.active_mods["debugadapter"] then require('__debugadapter__/debugadapter.lua') end
require("utils/functions.lua")
require("scripts/objects/YVPlayer.lua")

-- When the Mod initialize --
function onInit()
    global.playersTable = {}
end

-- When a save is loaded --
function onLoad()
    -- Set YVPlayer Metatable --
    for k, yvplayer in  pairs(global.playersTable or {}) do
        YVP:rebuild(yvplayer)
    end
end

-- Initialize the Player --
function initPlayer(event)
    local player = getPlayer(event.player_index)
    if player == nil or global.playersTable[player.name] ~= nil then return end
    
    -- Set reach distance --
    player.character_build_distance_bonus = 99999
    player.character_item_drop_distance_bonus = 99999
    player.character_reach_distance_bonus = 99999
    player.character_resource_reach_distance_bonus = 99999
    character_item_pickup_distance_bonus = 99999
    
    -- Create a new Force for each Player --
    if game.forces[player.name] == nil then
        local force = game.create_force(player.name)
        player.force = force
        for k, force2 in pairs(game.forces) do
            if force2.name ~= "enemy" then
                force.set_cease_fire(force2, true)
                force2.set_cease_fire(force, true)
            end
        end
    end

    -- Save the Player inside the Players Table --
    global.playersTable[player.name] = YVP:new(player)
end

----------------------------- Events -----------------------------
script.on_init(onInit)
script.on_load(onLoad)
script.on_event(defines.events.on_player_created, initPlayer)
script.on_event(defines.events.on_player_joined_game, initPlayer)