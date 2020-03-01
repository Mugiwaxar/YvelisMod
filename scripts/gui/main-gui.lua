function GUI.createMainGui(player)

    local gui = player.gui

    -- Determine the GUI location with the screen resolution --
    local posX = 0
    local posY = 0

    -- Verify if the Main GUI exist, save the positions and destroy it --
    if gui.screen.YvGUI ~= nil and gui.screen.YvGUI.valid == true then
        posX = gui.screen.YvGUI.location.x
        posY = gui.screen.YvGUI.location.y
        gui.screen.YvGUI.destroy()
    end

    -- Create the GUI --
	local YvGUI = gui.screen.add{type="frame", name="YvGUI", direction="vertical"}
	-- Set the GUI position end style --
	YvGUI.location = {posX, posY}
	YvGUI.style.padding = 0
    YvGUI.style.horizontal_align = "center"
    -- YvGUI.style.width = 100
    -- YvGUI.style.height = 100
    YvGUI.caption = "Yvelis"

	---------------------------------------------- MENU BAR ----------------------------------------------
	-- Create the Menu Flow --
    local yvGUIMenuFrame = YvGUI.add{type="flow", name="yvGUIMenuFrame", direction="horizontal"}
    -- yvGUIMenuFrame.style.width = 90
    -- yvGUIMenuFrame.style.height = 20
	-- Set Style --
	yvGUIMenuFrame.style.padding = 0
	yvGUIMenuFrame.style.margin = 0
	yvGUIMenuFrame.style.horizontal_align = "right"
	-- yvGUIMenuFrame.style.minimal_width = 150
	
	-- Create the Yvelis Label --
	local YvLabel = yvGUIMenuFrame.add{type="label", name="YvLabel", tooltip={"gui-description.Team"}}
	YvLabel.style.font = "LabelFont"

	-- Create the Online Players Label --
	local OPLabel = yvGUIMenuFrame.add{type="label", name="OPLabel", tooltip={"gui-description.OnlinePlayersTT"}}
	OPLabel.style.font = "LabelFont"
    
	-- Add the move Button to top Flow --
	yvGUIMenuFrame.add{
		type="sprite-button",
		name="YvMoveButton",
		sprite="MoveIcon",
		hovered_sprite="MoveIcon",
		resize_to_sprite=false,
		tooltip={"gui-description.moveGuiFrameButton"}
	}
	-- Set style --
	yvGUIMenuFrame.YvMoveButton.style.maximal_width = 15
	yvGUIMenuFrame.YvMoveButton.style.maximal_height = 15
	yvGUIMenuFrame.YvMoveButton.style.padding = 0
	
	-- Add the reduce Button to top Flow --
	yvGUIMenuFrame.add{
		type="sprite-button",
		name="YvReduceButton",
		sprite="ArrowIconDown",
		hovered_sprite="ArrowIconDown",
		resize_to_sprite=false,
		tooltip={"gui-description.reduceButton"}
	}
	-- Set style --
	yvGUIMenuFrame.YvReduceButton.style.maximal_width = 15
	yvGUIMenuFrame.YvReduceButton.style.maximal_height = 15
	yvGUIMenuFrame.YvReduceButton.style.right_margin = 0
	yvGUIMenuFrame.YvReduceButton.style.padding = 0

	---------------------------------------------- CENTER FLOW --------------------------------------------
	-- Create the center Flow --
	local YvGUICenterFrame = YvGUI.add{type="scroll-pane", name="YvGUICenterFrame", direction="vertical"}
	-- Set Style --
	YvGUICenterFrame.style.padding = 0
	YvGUICenterFrame.style.vertical_align = "top"
	-- YvGUICenterFrame.style.width = 80
	-- YvGUICenterFrame.style.height = 100
	YvGUICenterFrame.visible = false

	-- Create the Team Button --
	local TeamButton = YvGUICenterFrame.add {type="button", name="TeamButton", caption={"gui-description.TeamButton"}}
	TeamButton.style.width = 80
end

function GUI.updateMainGui(player)
	if player == nil then return end
	local gui = player.gui
	if gui.screen.YvGUI == nil then return end

    -- Count the number of online player --
    local playersOnline = 0
    for k, player in pairs(game.players) do
        if player.connected == true then playersOnline = playersOnline + 1 end
    end

	-- Update the Team Label --
    gui.screen.YvGUI.yvGUIMenuFrame.YvLabel.caption = "[color=blue]" .. player.force.name .. "[/color]"

    -- Update the OPLabel Label --
    gui.screen.YvGUI.yvGUIMenuFrame.OPLabel.caption = {"", {"gui-description.OnlinePlayers",playersOnline}}

    -- Create Players List --
    GUI.createPlayersList(gui.screen.YvGUI.yvGUIMenuFrame.OPLabel)
end

-- Create a list of Players inside the gui --
function GUI.createPlayersList(gui)
    local text = "Online Player:"
    for k, player in pairs(game.players) do
        if player.connected == true then
            text = {"", text, "\n[color=green]", player.name ,"[/color]"}
        end
    end
    gui.tooltip = text
end