Inventory = class("Inventory")

function Inventory:initialize()
	self.slots_hotbar = 5
	self.slots_inventory = 24
	self.open = false
end

function Inventory:update(dt)
	if keyReseter == "b" or keyReseter == "i" then
		if self.open then
			Timer.add(.1,function() self.open = false end)
		elseif self.open == false then
			Timer.add(.1,function() self.open = true end)
		end
	end
end

function Inventory:draw()
	if self.open then
		color(green)
		rect("fill",100,75,600,400)
	end
	
end