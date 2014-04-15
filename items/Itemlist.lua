local itemlist = {
	hammer = {
		func = breakBlock(),
		amount = 0,
		maxDurability = 100,
		damageDura = 2,
		maxAmount = 64,
		image = love.graphics.newQuad(0,0,24,24,48,48),
	},
}

return itemlist