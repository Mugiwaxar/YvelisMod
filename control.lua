GUI = {}

if script.active_mods["debugadapter"] then require('__debugadapter__/debugadapter.lua') end
require("utils/functions.lua")
require("scripts/objects/YVPlayer.lua")
require("scripts/objects/YVTeam.lua")
require("scripts/gui/gui.lua")
require("scripts/game-update.lua")

-- When the Mod initialize --
function onInit()
    global.playersTable = {}
    global.teamTable = {}
    for k, player in pairs(game.players) do
        initPlayer({player_index=player.index})
    end
end

-- When a save is loaded --
function onLoad()
    -- Set YVPlayer Metatables --
    for k, yvplayer in pairs(global.playersTable or {}) do
        YVP:rebuild(yvplayer)
    end
    -- Set YVTeam Metatables --
    for k, yvteam in pairs(global.teamTable or {}) do
        YVT:rebuild(yvteam)
    end
end

function onConfigurationChanged()
    -- Update all Variables --
	updateValues()
    -- Update all GUIs --
    for k, player in pairs(game.players) do
        if global.playersTable[player.name] == nil then initPlayer({player_index=player.index}) end
        GUI.createAllGui(player)
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

    -- Create the YVTeam --
    YVT.newTeamObj(global.playersTable[player.name])

    -- Create all GUI --
    GUI.createAllGui(player)
end

----------------------------- Events -----------------------------
script.on_init(onInit)
script.on_load(onLoad)
script.on_configuration_changed(onConfigurationChanged)
script.on_event(defines.events.on_player_created, initPlayer)
script.on_event(defines.events.on_player_joined_game, initPlayer)
script.on_event(defines.events.on_tick, onTick)
script.on_event(defines.events.on_gui_click, GUI.buttonClicked)
script.on_event(defines.events.on_gui_elem_changed, GUI.onGuiElemChanged)
script.on_event(defines.events.on_gui_checked_state_changed, GUI.onGuiElemChanged)
script.on_event(defines.events.on_gui_selection_state_changed, GUI.onGuiElemChanged)
script.on_event(defines.events.on_gui_text_changed, GUI.onGuiElemChanged)