-- Advenced print --
function dprint(v)
	game.print(serpent.block(v))
end

-- Return the player object with his id --
function getPlayer(id)
	return game.players[id]
end