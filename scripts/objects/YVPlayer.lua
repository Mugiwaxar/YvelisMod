-- Create the YVPlayer Object --
YVP = {
    ent = nil,
    name = nil
}

-- Constructor --
function YVP:new(player)
    if player == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
    mt.__index = MF
    t.ent = player
    t.name = player.name
	return t
end

-- Reconstructor --
function YVP:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = MF
	setmetatable(object, mt)
end