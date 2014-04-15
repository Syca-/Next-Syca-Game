local blocklist = {
	wall_wood = {
		name = "wall_wood",
		func= function() end,
		amount = 0,
		maxDurability = 100,
		damageDura = 2,
		maxAmount = 64,
		image = love.graphics.newQuad(24,0,24,24,48,48),
	},

	door_wood = {
		name = "door_wood",
		func= function() end,
		amount = 0,
		maxDurability = 100,
		damageDura = 2,
		maxAmount = 64,
		image = love.graphics.newQuad(0,0,24,24,48,48),
	},

	floor_concrete = {
		name = "floor_concrete",
		func= function() end,
		amount = 0,
		maxDurability = 100,
		damageDura = 2,
		maxAmount = 64,
		image = love.graphics.newQuad(0,24,24,24,48,48),
	},

	window_concrete = { 
		name = "window_concrete",
		func= function() end,
		amount = 0,
		maxDurability = 100,
		damageDura = 2,
		maxAmount = 64,
		image = love.graphics.newQuad(24,24,24,24,48,48)
	},
}

return blocklist