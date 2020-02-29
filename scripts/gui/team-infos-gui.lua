function GUI.createTeamInfoGui(player, YVTeam)
    local gui = player.gui
    local isMember = false
    local isLeader = false
    local playerYVTeam = YVT.getYVTeamP(player)
    if playerYVTeam == YVTeam then isMember = true end
    if YVTeam:isLeader(player) then isLeader = true end

    -- Determine the GUI location with the screen resolution --
    local resolutionWidth = player.display_resolution.width -- / player.display_scale
    local resolutionHeight = player.display_resolution.height -- / player.display_scale
    local posX = resolutionWidth / 2 - 100
    local posY = resolutionHeight / 2 - 200

    -- Create the GUI --
    local TeamInfoGUI = gui.screen.add{type="frame", name="TeamInfoGUI", direction="vertical"}
    -- Set the GUI position end style --
    TeamInfoGUI.location = {posX, posY}
    TeamInfoGUI.style.padding = 0
    TeamInfoGUI.style.horizontal_align = "left"
    -- TeamGUI.style.width = 400
    -- TeamGUI.style.height = 400
    TeamInfoGUI.caption = YVTeam.name

    -- Create the Menu Flow --
    local TeamInfoGUIMenuFrame = TeamInfoGUI.add{type="flow", name="TeamInfoGUIMenuFrame", direction="horizontal"}
    TeamInfoGUIMenuFrame.style.padding = 0
    TeamInfoGUIMenuFrame.style.margin = 0
    TeamInfoGUIMenuFrame.style.horizontal_align = "right"
    
    -- Add the Close Button to top Flow --
    TeamInfoGUIMenuFrame.add{
        type="sprite-button",
        name="TeamInfoGUICloseButton",
        sprite="CloseIcon",
        hovered_sprite="CloseIcon",
        resize_to_sprite=false,
        tooltip={"gui-description.closeButton"}
    }
    TeamInfoGUIMenuFrame.TeamInfoGUICloseButton.style.maximal_width = 15
    TeamInfoGUIMenuFrame.TeamInfoGUICloseButton.style.maximal_height = 15
    TeamInfoGUIMenuFrame.TeamInfoGUICloseButton.style.padding = 0

    -- Create the Change Team Name Flow --
    local CTNFlow = TeamInfoGUI.add{type="flow", name="CTNFlow", direction="horizontal"}
    CTNFlow.visible = isLeader

    -- Create the change Team name TextField --
    local CTNTextfield = CTNFlow.add{type="textfield", name="CTNTextfield", tooltip={"gui-description.ChangeTeamNameTT"}, text=YVTeam.name}

    -- Create the Change Team name Button --
    local TeamButton = CTNFlow.add {type="button", name="TGUIChangeTeamNameButton", caption="ok"}
    TeamButton.style.width = 40

    -- Create the Accept Player Check Box --
    local APButton = TeamInfoGUI.add{type="checkbox", name="TGUIAcceptPlayers", caption={"gui-description.AcceptPlayer"}, state=YVTeam.allowJoin, tooltip={"gui-description.AcceptPlayerTT"}, enabled=isLeader}

    -- Create the in peace/in war Label --
    if isMember == false and YVTeam:isInPeace(playerYVTeam) then
        TeamInfoGUI.add{type="label", caption={"gui-description.InPeaceWith", playerYVTeam.name}, tooltip={"gui-description.InPeaceWithTT"}}
    elseif isMember == false then
        TeamInfoGUI.add{type="label", caption={"gui-description.InWarWith", playerYVTeam.name}, tooltip={"gui-description.InWarWithTT"}}
    end

    -- Create the Join Team Button --
    if isMember == false then
        local joinButton = TeamInfoGUI.add{type="button", name="TGUIjoinButton" .. YVTeam.name, caption={"gui-description.Join"}, tooltip={"gui-description.JoinTT"}, enabled=YVTeam.allowJoin}
    end
end