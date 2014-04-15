require "Player.Inventory"

GUI = class("GUI")

bg = {hpBg={x=40,y=550,width=200,height=25},mpBg={x=550,y=550,width=200,height=25}}
	bars = {health={x=40,y=550,width=player.health,height=25,color=red},mana={x=550,y=550,width=player.mana,height=25,color=blue}}
	outlines = {one={x=40,y=550,width=200,height=25}, two={x=550,y=550,width=200,height=25},
		three={x=41,y=551,width=199,height=24},four={x=551,y=551,width=199,height=24},
		five={x=42,y=552,width=198,height=23}, six={x=552,y=552,width=198,height=23}
	}
--##########################################################################################################################################--
function GUI:initialize()
	inventory = Inventory:new()
	self.enabled = true
	
	
end

--##########################################################################################################################################--
function GUI:update(dt)
	inventory:update(dt)

	if keyReseter == "f1" then
		if self.enabled then
			self.enabled = false
		elseif self.enabled == false then
			self.enabled = true
		end
	end
end

--##########################################################################################################################################--
function GUI:draw()
	if self.enabled then
		inventory:draw()
		color(black)
		for i,v in pairs(bg) do
			rect("fill",v.x,v.y,v.width,v.height)
		end

		for i,v in pairs(bars) do
			color(v.color)
			rect("fill",v.x,v.y,v.width,v.height)
		end

		color(125,125,0,255)
		for i,v in pairs(outlines) do
			rect("line",v.x,v.y,v.width,v.height)
		end
		color(white)
		lg.print("FPS: "..love.timer.getFPS(),400,0)
	end
end

--##########################################################################################################################################--