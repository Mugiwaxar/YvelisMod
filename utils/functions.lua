-- Advenced print --
function dprint(v)
	game.print(serpent.block(v))
end

-- Return a splitted table of a string --
function split(str, char)
	char = "[^" .. char .."]+"
	local parts = {__index = table.insert}
	setmetatable(parts, parts)
	str:gsub(char, parts)
	setmetatable(parts, nil)
	parts.__index = nil
	return parts
 end

-- Return the player object with his id --
function getPlayer(id)
	return game.players[id]
end