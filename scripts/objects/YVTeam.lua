-- Create the YVTeam Object --
YVT = {
    leader = nil,
    name = nil,
    YVPlayersTable = nil,
    allowJoin = false
}

-- Constructor --
function YVT:new(YVPlayer)
    if YVPlayer == nil then return end
    local t = {}
    local mt = {}
    setmetatable(t, mt)
    mt.__index = YVT
    t.leader = YVPlayer
    t.name = YVPlayer.ent.force.name
    t.YVPlayersTable = {}
    t.YVPlayersTable[YVPlayer.name] = YVPlayer
    return t
end

-- Reconstructor --
function YVT:rebuild(object)
    if object == nil then return end
    local mt = {}
    mt.__index = YVT
    setmetatable(object, mt)
end

-- Create a new YVTeam Object --
function YVT.newTeamObj(player)
    local YVTeam = YVT:new(player)
    table.insert(global.teamTable, YVTeam)
    return YVTeam
end

-- Create a new Team(force) --
function YVT.newTeam(player, newName)
    if game.forces[newName] ~= nil then
        player.print({"gui-description.FNameUsed"})
        return
    end
    local newForce = game.create_force(newName)
    local oldYVTeam = YVT.getYVTeamP(player)
    oldYVTeam:removePlayer(global.playersTable[player.name], newForce)
    player.force = newForce
    YVT.newTeamObj(global.playersTable[player.name])
    for k, force in pairs(game.forces) do
        newForce.set_cease_fire(force, true)
        force.set_cease_fire(newForce, true)
    end
end

-- Get a YVTeam --
function YVT.getYVTeamP(player)
    for k, yvteam in pairs(global.teamTable) do
        if player.force.name == yvteam.name then
            return yvteam
        end
    end
end
function YVT.getYVTeamPN(playerName)
    local YVPlayer = global.playersTable[playerName]
    for k, yvteam in pairs(global.teamTable) do
        if YVPlayer.ent.force.name == yvteam.name then
            return yvteam
        end
    end
end
function YVT.getYVTeamF(force)
    for k, yvteam in pairs(global.teamTable) do
        if force.name == yvteam.name then
            return yvteam
        end
    end
end

-- Remove an YVTeam --
function YVT.removeYVTeam(YVTeamName)
    for k, yvteam in pairs(global.teamTable) do
        if YVTeamName == yvteam then
            global.teamTable[k] = nil
        end
    end
end

-- Change the Team name --
function YVT:changeName(newName)
    if game.forces[newName] ~= nil then
        self.leader.ent.print({"gui-description.FNameUsed"})
        return
    end
    local player = self.leader.ent
    local newForce = game.create_force(newName)
    for k, force in pairs(game.forces) do
        newForce.set_cease_fire(force, player.force.get_cease_fire(force))
        force.set_cease_fire(newForce, force.get_cease_fire(player.force))
    end
    for k, tech in pairs(player.force.technologies) do
        newForce.technologies[tech.name].researched = true
    end
    game.merge_forces(player.force, newForce)
    YVT.getYVTeamP(player).name = newName
end

-- Change a Player Team --
function YVT.transferPlayer(player, oldYvTeam, newYvTeam)
    oldYvTeam:removePlayer(player, newYvTeam.leader.ent.force)
    newYvTeam:addPlayer(player)
end

-- Add a Player to the Team --
function YVT:addPlayer(YVPlayer)
    YVPlayer.ent.force = self.leader.ent.force
    self.YVPlayersTable[YVPlayer.name] = YVPlayer
end

-- Remove a Player from the Team --
function YVT:removePlayer(YVPlayer, newForce)
    if self.YVPlayersTable[YVPlayer.name].name == self.leader.name then
        if table_size(self.YVPlayersTable) <= 1 then
            game.merge_forces(YVPlayer.ent.force, newForce.name)
            YVT.removeYVTeam(self)
        else
            for k, YVPlayer2 in pairs(self.YVPlayersTable) do
                self.leader = YVPlayer2
                break
            end
        end
    end
    self.YVPlayersTable[YVPlayer.name] = nil
end

-- Make peace with an other Team --
function YVT:makePeace(YVTeam)
    self.leader.force.set_cease_fire(YVTeam.leader.force, true)
end

-- Make war againts an other Team --
function YVT:makeWar(YVTeam)
    self.leader.force.set_cease_fire(YVTeam.leader.force, false)
end

-- Return the peace statue --
function YVT:isInPeace(YVTeam)
    return self.leader.ent.force.get_cease_fire(YVTeam.leader.ent.force)
end

-- Return the friend statue --
function YVT:isFriends(YVTeam)
    return self.leader.ent.force.get_friend(YVTeam.leader.ent.force)
end

-- Return if the Player is the Lead of the Team --
function YVT:isLeader(Player)
    if Player == self.leader.ent then return true end
    return false
end