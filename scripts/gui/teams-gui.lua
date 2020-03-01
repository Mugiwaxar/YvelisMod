function GUI.createTeamGui(player)
    local gui = player.gui

    -- Determine the GUI location with the screen resolution --
    local resolutionWidth = player.display_resolution.width -- / player.display_scale
    local resolutionHeight = player.display_resolution.height -- / player.display_scale
    local posX = 100
    local posY = 100

    -- Verify if the Team GUI exist, save the positions and destroy it --
    if gui.screen.TeamGUI ~= nil and gui.screen.TeamGUI.valid == true then
        posX = gui.screen.TeamGUI.location.x
        posY = gui.screen.TeamGUI.location.y
        gui.screen.TeamGUI.destroy()
    end

    -- Create the GUI --
    local TeamGUI = gui.screen.add{type="frame", name="TeamGUI", direction="vertical"}
    -- Set the GUI position end style --
    TeamGUI.location = {0, 0}
    TeamGUI.style.padding = 0
    TeamGUI.style.horizontal_align = "left"
    -- TeamGUI.style.width = 400
    -- TeamGUI.style.height = 400
    TeamGUI.caption = "Yvelis"
    TeamGUI.visible = false

	-- Create the Menu Flow --
    local TeamGUIMenuFrame = TeamGUI.add{type="flow", name="TeamGUIMenuFrame", direction="horizontal"}
	TeamGUIMenuFrame.style.padding = 0
	TeamGUIMenuFrame.style.margin = 0
    TeamGUIMenuFrame.style.horizontal_align = "right"
    
    -- Add the Close Button to top Flow --
	TeamGUIMenuFrame.add{
		type="sprite-button",
		name="TeamGUICloseButton",
		sprite="CloseIcon",
		hovered_sprite="CloseIcon",
		resize_to_sprite=false,
		tooltip={"gui-description.closeButton"}
	}
	TeamGUIMenuFrame.TeamGUICloseButton.style.maximal_width = 15
	TeamGUIMenuFrame.TeamGUICloseButton.style.maximal_height = 15
	TeamGUIMenuFrame.TeamGUICloseButton.style.padding = 0

    -- Create the first flow --
    local TGUIFirstFlow = TeamGUI.add{type="flow", name="TGUIFirstFlow", direction="horizontal"}

    -- Create the My Name Label--
    local myNameLabel = TGUIFirstFlow.add{type="label", name="myNameLabel", caption={ "", "[color=green]" .. player.name .. "[/color]", ": "}, tooltip={"gui-description.MyNameTT"}}

    -- Create the My Team Label--
    local myTeamLabel = TGUIFirstFlow.add{type="label", name="myTeamLabel", caption={ "", "[color=blue]" .. YVT.getYVTeamP(player).name .. "[/color]", ": "}, tooltip={"gui-description.MyTeamTT"}}

    -- Create the Team Info Button --
    local teamInfoButton = TGUIFirstFlow.add{type="button", name="teamInfoButton" .. player.name, caption={"gui-description.Infos"}, tooltip={"gui-description.InfosTT"}}

    -- Create the Create Team Button --
    local createTeamButton = TGUIFirstFlow.add{type="button", name="createTeamButton", caption={"gui-description.CreateTeam"}, tooltip={"gui-description.CreateTeamTT"}}

    -- Add the Line --
    TeamGUI.add{type="line", direction="horizontal"}

    -- Create the second flow --
    local TGUISecondFlow = TeamGUI.add{type="flow", name="TGUISecondFlow", direction="vertical"}
end

-- Update the Team GUI --
function GUI.updateTeamGUI(player)

    -- Create and Check the TeamGUI --
    local TeamGUI = player.gui.screen.TeamGUI
    if TeamGUI == nil then return end
    if TeamGUI.visible == false then return end
    if TeamGUI.TGUISecondFlow ~= nil then TeamGUI.TGUISecondFlow.clear() end
    local YVTeam = YVT.getYVTeamP(player)

    -- Update the Team name --
    TeamGUI.TGUIFirstFlow.myTeamLabel.caption = { "", "[color=blue]" .. YVT.getYVTeamP(player).name .. "[/color]"}

    -- Create all Players line --
    for k, player2 in pairs(game.players) do
        createPlayerLine(TeamGUI.TGUISecondFlow, player2, player)
    end
end

-- Create a Player line --
function createPlayerLine(gui, player, currentPlayer)
    local YVTeam = YVT.getYVTeamP(currentPlayer)
    local YVTeam2 = YVT.getYVTeamP(player)
    local playerName = "[color=red]" .. player.name ..": [/color]"
    local connectStatue = {"gui-description.Offline"}
    if player.connected == true then
        playerName = "[color=green]" .. player.name ..": [/color]"
        connectStatue = {"gui-description.Online"}
    end
    if currentPlayer ~= player then
        local playerFlow = gui.add{type="flow", name="TGUIplayerFlow" .. player.name, direction="horizontal"}
        local playerLabel = playerFlow.add{type="label", name="TGUPlayerLabel" .. player.name, caption=playerName, tooltip=connectStatue}
        local teamLabel = playerFlow.add{type="label", name="TGUIteamLabel" .. player.name, caption="[color=blue]" ..player.force.name .. "[/color]", tooltip={"", {"gui-description.Leader"}, ": ", YVTeam2.leader.name}}
        local friendCheckBox = playerFlow.add{type="checkbox", name="TGUIFriendCheckBox" .. player.name, caption={"gui-description.Friend"}, tooltip={"gui-description.FriendTT"}, state=YVTeam:isFriends(YVTeam2), enabled=YVTeam:isLeader(currentPlayer)}
        local warCheckBox = playerFlow.add{type="checkbox", name="TGUIWarCheckBox" .. player.name, caption={"gui-description.War"}, tooltip={"gui-description.WarTT"}, state=not YVTeam:isInPeace(YVTeam2), enabled=YVTeam:isLeader(currentPlayer)}
        local infoButton = playerFlow.add{type="button", name="teamInfoButton" .. player.name, caption={"gui-description.Infos"}, tooltip={"gui-description.InfosTT"}}
    end
end

-- Open the Team Name GUI --
function GUI.OpenTeamName(player)

    -- Determine the GUI location with the screen resolution --
    local resolutionWidth = player.display_resolution.width -- / player.display_scale
    local resolutionHeight = player.display_resolution.height -- / player.display_scale
    local posX = resolutionWidth / 2 - 200
    local posY = resolutionHeight / 2 - 80

    -- Create the Create Team Flow --
    local CTFrame = player.gui.screen.add{type="frame", name="CTFrame", direction="horizontal", caption={"gui-description.TeamName"}}
    CTFrame.location = {posX, posY}

    -- Create the Create Team TextField --
    local CTTextfield = CTFrame.add{type="textfield", name="CTTextfield", tooltip={"gui-description.ChangeTeamNameTT"}}

    -- Create the Create Team Button --
    local TeamButtonOk = CTFrame.add {type="button", name="TeamButtonOk", caption="ok"}
    TeamButtonOk.style.width = 40

    -- Create the Cancel Team Button --
    local TeamButtonCancel = CTFrame.add {type="button", name="TeamButtonCancel", caption="X"}
    TeamButtonCancel.style.width = 40
end