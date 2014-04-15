local _blocks = require("Blocks.Blocklist")
Blocks = class("Blocks")

function Blocks:initialize(name,x,y)
	self.name = name
	self.x=x
	self.y=y

	for i,v in pairs(_blocks) do

		if v.name==self.name then
			self.func = v.func
			self.maxDurability = v.maxDurability
			self.currentDurability = self.maxDurability
			self.damageDurability = v.damageDurability
			self.maxAmount = v.maxAmount
			self.amount = 1
			self.image = v.image
		end

	end

end