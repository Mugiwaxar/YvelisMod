require("scripts/gui/main-gui.lua")
require("scripts/gui/teams-gui.lua")
require("scripts/gui/team-infos-gui.lua")

function GUI.createAllGui(player)
    GUI.createMainGui(player)
    GUI.createTeamGui(player)
end

function GUI.updateGUI(player)
	GUI.updateMainGui(player)
	GUI.updateTeamGUI(player)
end

-- When a GUI Button is clicked --
function GUI.buttonClicked(event)
	-- Return if the Element is not valid --
	if event.element == nil or event.element.valid == false then return end
	-- Return if this is not a Mobile Factory element --
	if event.element.get_mod() ~= "Yvelis_Mod" then return end
    -- Get the Player --
    local player = getPlayer(event.player_index)
    if player == nil then return end

    -- Move GUI Button --
	if event.element.name == "YvMoveButton" then
		if player.gui.screen.YvGUI.caption == "" then
			player.gui.screen.YvGUI.caption = "Yvelis"
			player.gui.screen.YvGUI.location.y = player.gui.screen.YvGUI.location.y + 10
		else
			player.gui.screen.YvGUI.caption = ""
			player.gui.screen.YvGUI.location.y = player.gui.screen.YvGUI.location.y - 10
		end
		return
    end
    
    -- Reduce GUI Button --
	if event.element.name == "YvReduceButton" then
		if player.gui.screen.YvGUI.YvGUICenterFrame.visible == false then
			player.gui.screen.YvGUI.YvGUICenterFrame.visible = true
			player.gui.screen.YvGUI.yvGUIMenuFrame.YvReduceButton.sprite = "ArrowIconUp"
			player.gui.screen.YvGUI.yvGUIMenuFrame.YvReduceButton.hovered_sprite = "ArrowIconUp"
		else
			player.gui.screen.YvGUI.YvGUICenterFrame.visible = false
			player.gui.screen.YvGUI.yvGUIMenuFrame.YvReduceButton.sprite = "ArrowIconDown"
			player.gui.screen.YvGUI.yvGUIMenuFrame.YvReduceButton.hovered_sprite = "ArrowIconDown"
		end
		return
	end

	-- Team GUI Button --
	if event.element.name == "TeamButton" then
		if player.gui.screen.TeamGUI.visible == false then
			player.gui.screen.TeamGUI.visible = true
		else
			player.gui.screen.TeamGUI.visible = false
		end
		return
	end

	-- Team GUI Close Button --
	if event.element.name == "TeamGUICloseButton" then
		player.gui.screen.TeamGUI.visible = false
		return
	end

	-- Team Info GUI Button --
	if string.match(event.element.name, "teamInfoButton") then
		local playerName = string.gsub(event.element.name, "teamInfoButton", "")
		if player.gui.screen.TeamInfoGUI ~= nil then
			player.gui.screen.TeamInfoGUI.destroy()
		end
		GUI.createTeamInfoGui(player, YVT.getYVTeamPN(playerName))
		return
	end

	-- Team Info GUI Close Button --
	if event.element.name == "TeamInfoGUICloseButton" then
		player.gui.screen.TeamInfoGUI.destroy()
		return
	end

	-- Create Team Button --
	if event.element.name == "createTeamButton"  then
		if player.gui.screen.CTFrame == nil then GUI.OpenTeamName(player) end
		return
	end

	-- Change Team name Button --
	if string.match(event.element.name, "TGUIChangeTeamNameButton") then
		local YVTeam = YVT.getYVTeamP(player)
		if YVTeam:isLeader(player) then
			game.print({"gui-description.ChangedTeamName", YVTeam.name, player.gui.screen.TeamInfoGUI.CTNFlow.CTNTextfield.text})
			YVTeam:changeName(player.gui.screen.TeamInfoGUI.CTNFlow.CTNTextfield.text)
		end
		return
	end

	-- Ok Create Team Button --
	if event.element.name == "TeamButtonOk"  then
		if player.gui.screen.CTFrame ~= nil then
			local newName = player.gui.screen.CTFrame.CTTextfield.text
			if newName == "" then return end
			YVT.newTeam(player, newName)
			player.gui.screen.CTFrame.destroy()
			game.print({"gui-description.NewTeam", player.name, newName})
		end
		return
	end
	
	-- Cancel Create Team Button --
	if event.element.name == "TeamButtonCancel"  then
		if player.gui.screen.CTFrame ~= nil then player.gui.screen.CTFrame.destroy() end
		return
	end

	-- Team Join Button --
	if string.match(event.element.name, "TGUIjoinButton") then
		local teamName = string.gsub(event.element.name, "TGUIjoinButton", "")
		local YVTeam1 = YVT.getYVTeamP(player)
		local YVTeam2 = YVT.getYVTeamFN(teamName)
		player.gui.screen.TeamInfoGUI.destroy()
		if YVTeam2.allowJoin == true then
			YVT.transferPlayer(global.playersTable[player.name], YVTeam1, YVTeam2)
			game.print({"gui-description.JoinedTeam", player.name, YVTeam2.name})
		end
		return
	end
end

-- When a GUIElement change --
function GUI.onGuiElemChanged(event)
	-- Return if the Element is not valid --
	if event.element == nil or event.element.valid == false then return end
	-- Return if this is not a Mobile Factory element --
	if event.element.get_mod() ~= "Yvelis_Mod" then return end
	-- Get the Player --
	local player = getPlayer(event.player_index)
	-- Ckeck the Player --
	if player == nil then return end

	-- Team accept new Players --
	if string.match(event.element.name, "TGUIAcceptPlayers") then
		local YVTeam = YVT.getYVTeamP(player)
		if YVTeam:isLeader(player) then
			YVTeam.allowJoin = event.element.state
			if event.element.state == true then
				game.print({"gui-description.TeamAcceptPlayers", YVTeam.name})
			else
				game.print({"gui-description.TeamNoAcceptPlayers", YVTeam.name})
			end
		end
		return
	end

	-- Team friend --
	if string.match(event.element.name, "TGUIFriendCheckBox") then
		local playerName = string.gsub(event.element.name, "TGUIFriendCheckBox", "")
		local YVTeam1 = YVT.getYVTeamP(player)
		local YVTeam2 = YVT.getYVTeamPN(playerName)
		if YVTeam1:isLeader(player) then
			YVTeam1.leader.ent.force.set_friend(YVTeam2.name, event.element.state)
			if event.element.state == true then
				game.print({"gui-description.NowFriends", YVTeam1.name, YVTeam2.name})
				YVTeam1.leader.ent.force.set_cease_fire(YVTeam2.leader.ent.force, true)
			else
				game.print({"gui-description.NotNowFriends", YVTeam1.name, YVTeam2.name})
			end
		end
		return
	end

	-- Team peace or war --
	if string.match(event.element.name, "TGUIWarCheckBox") then
		local playerName = string.gsub(event.element.name, "TGUIWarCheckBox", "")
		local YVTeam1 = YVT.getYVTeamP(player)
		local YVTeam2 = YVT.getYVTeamPN(playerName)
		if YVTeam1:isLeader(player) then
			YVTeam1.leader.ent.force.set_cease_fire(YVTeam2.leader.ent.force, not event.element.state)
			if event.element.state == true then
				game.print({"gui-description.WarTo", YVTeam1.name, YVTeam2.name})
				YVTeam1.leader.ent.force.set_friend(YVTeam2.name, false)
			else
				game.print({"gui-description.PeaceTo", YVTeam1.name, YVTeam2.name})
			end
		end
		return
	end
end