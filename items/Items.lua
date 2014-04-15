function breakBlock()

end

local _items = require("Items.Itemlist")
Items = class("Items")

function Items:initialize(name)
	self.name = name
	self.x=0
	self.y=0

	if _items[self.name] then
		self.func = _items[self.name].func
		self.maxDurability = _items[self.name].maxDurability
		self.currentDurability = self.maxDurability
		self.damageDurability = _items[self.name].damageDurability
		self.maxAmount = _items[self.name].maxAmount
		self.amount = 1
	end
end