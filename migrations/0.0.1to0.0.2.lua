-- Create YVTeams --
global.teamTable = {}
for k, player in pairs(game.players) do
	YVT.newTeamObj(global.playersTable[player.name])
end