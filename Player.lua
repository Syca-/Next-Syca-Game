--##########################################################################################################################################--

--#######################################################[[  Player  }}#####################################################################--

--##########################################################################################################################################--
require "Ai.Creature" 

local keyCheck
local keyReleasedCheck = 0
local numberCheck = 0
local joyCheck = {Lr=false,Ll=false,Lu=false,Ld=false,a=false}
local keyDown = love.keyboard.isDown
local selSlot = 1
local time = 0
local timeLimit = .2

Player = class("Player", Creature)

--##########################################################################################################################################--
function Player:initialize(name, x, y)
	--object variables
	self.name = name
	self.img =  love.graphics.newImage("art/player.png")
	self.img:setFilter("nearest","nearest")
	self.x = y
	self.y = x
	self.size=24
	self.width = self.size
	self.height = self.size
	self.speed = 200
	self.friction = 2.5
	self.facing = "south"
	--helpful things
	self.player = true
	self.dt = 0
	self.Enabled = true
	self.placer = {x=self.x+(self.width),y= (self.y+self.height)+self.size/2,width=6,height=6}
	self.inventoryOpen = false
	self.canPlace = true
	self.keyCheck = keyCheck
	self.gridx=x
	self.gridy=y
	self.hotbarSlots = {
		{x=340-36,y=550,size=32,func=function() self:breakBlock() end,img=tiles.temp}, -- slot 1
		{x=380-36,y=550,size=32,func=nil,img=nil}, -- slot 2 
		{x=420-36,y=550,size=32,func=nil,img=nil}, -- slot 3
		{x=460-36,y=550,size=32,func=nil,img=nil}, -- slot 4
		{x=500-36,y=550,size=32,func=nil,img=nil} -- slot 5
	}
end

--##########################################################################################################################################--
function Player:update(dt)
	if joyConnected then 
		self:stick(dt)
	end

	self:move(dt)
	self:useHotbar(dt)
	self.keyCheck = keyCheck
	if self.x <= 0 then
		self.x = 0
	elseif self.x >=2400 then
		self.x = 2400
	end
	if self.y <= 0 then
		self.y = 0
	elseif self.y >=2400 then
		self.y = 2400
	end
end

--##########################################################################################################################################--
function Player:draw()
	color(white)
	draw(self.img,self.x,self.y)
	--rect("fill",self.x,self.y,self.size,self.size)
	color(red)
	rect("line",self.placer.x,self.placer.y,self.placer.width,self.placer.height)
	if self.facing == "west" then
		self.placer = {x=self.x-12,y= self.y+(self.height/3),width=6,height=6}
	elseif self.facing == "east"then
		self.placer={x=self.x+self.width+6,y= self.y+(self.height/3),width=6,height=6}
	elseif self.facing == "north"then
		self.placer = {x=self.x+(self.width/3),y= self.y-12,width=6,height=6}
	elseif self.facing == "south"then
		self.placer = {x=self.x+(self.width/3),y= (self.y+self.height)+12-6,width=6,height=6}
	end
end

--##########################################################################################################################################--
function Player:move(dt)
	
	--movement
	--horizon
	if (keyDown("d"))then
			self.x = self.x + self.speed*dt
			self.facing = "east"
	elseif (keyDown("a"))then  
			self.x = self.x - self.speed*dt
			self.facing = "west"
	end
	--placement control horizon
	
	--vertical
	if (keyDown("w"))then
		self.y = self.y - self.speed*dt
		self.facing = "north"

	elseif (keyDown("s"))then
		self.y = self.y + self.speed*dt
		self.facing = "south"
	end
	--placement control
	if (keyCheck=="up") then
			self.facing = "north"
	elseif (keyCheck=="down") then
			self.facing = "south"
	elseif (keyCheck=="right") then
			self.facing = "east"
	elseif (keyCheck=="left") then
			self.facing = "west"
	end

	for i,v in pairs(blocks)do
		if aabb(self.placer,blocks[i]) then
			if keyCheck=="e" and v.door and v.doorOpen==false then
				v.doorOpen= true
			end
			if keyCheck=="e" and v.door and v.doorOpen then
				Timer.add(1,function()v.doorOpen = false end)
			end
		end
	end
	
end

--##########################################################################################################################################--
function Player:useHotbar(dt)
	local hotbarSlot = {self.hotbarSlots.func(),function() self:place({102,51,0},true) end,function() self:place(blue,nil,nil,true) end,function() self:place({150,150,0},nil,true) end,function() self:place({155,60,255},nil,nil,true) end}
	if keyCheck==" " then
		if self.canPlace then
			time = time - dt
			if time <=0 then
				hotbarSlot[selSlot]()
				time = timeLimit
			end
		end
	end 
end

--##########################################################################################################################################--
function Player:place(color,door,floor,wall)
	local block = {x=0,y=0,width = 24,height=24,size=24,color=color,door=door,doorOpen=false,floor=floor,wall=wall}

	block.y= self.gridy
	block.x = self.gridx
	table.insert(blocks,block)
end

--##########################################################################################################################################--
function Player:breakBlock()
	for i,v in pairs(blocks)do
		if aabb(self.placer,blocks[i]) then
			table.remove(blocks,i)
		end
	end
end

--##########################################################################################################################################--
function Player:keyPressed(key)
	keyCheck = key
	if tonumber(key) then
		if tonumber(key) <= 5 and tonumber(key) > 0 then
			numberCheck = tonumber(key)
		end
	end

end

function Player:keyReleased(key)
	keyReleasedCheck = key
end

function Player:stick(dt)
	-- left stick --

	local leftx = Joystick:getGamepadAxis("leftx")
	local lefty = Joystick:getGamepadAxis("lefty")

	-- left x axis --

	if leftx >0 and leftx < 1 then
		leftx = 0
		joyCheck.Lr = false
	end
	if leftx <0 and leftx >-1 then
		leftx =0
		joyCheck.Ll = false
	end
	if leftx == 1 then
		joyCheck.Lr = true
	elseif leftx == -1 then
		joyCheck.Ll = true
	elseif leftx == 0 then
		joyCheck.Ll = false
		joyCheck.Lr = false
	end
	-- left y axis --

	if lefty >0 and lefty < 1 then
		lefty = 0
		joyCheck.Ld = false
	end
	if lefty <0 and lefty >-1 then
		lefty =0
		joyCheck.Lu = false
	end
	if lefty == 1 then
		joyCheck.Ld = true
	elseif lefty == -1 then
		joyCheck.Lu = true
	elseif lefty == 0 then
		joyCheck.Ld = false
		joyCheck.Lu = false
	end
end

--##########################################################################################################################################--

function Player:Interface()
	local invDone=false
	local invKeyCheck = 0
	
	local invSlots = {}
	if invDone==false then
		for k=35,490,70 do
			for b=75,670,70 do
				table.insert(invSlots,{x=b,y=k,size=64,width=64,height=64,func=nil,image=nil})
				invDone=true	
			end
		end
	end
	if numberCheck ~= nil then
		invKeyCheck = numberCheck
	end

	if invKeyCheck == 1 and selSlot ~=1 then	
		selSlot = 1
	elseif invKeyCheck == 2 and selSlot ~=2 then
		selSlot = 2
	elseif invKeyCheck == 3 and selSlot ~=3  then
		selSlot = 3
	elseif invKeyCheck == 4 and selSlot ~=4 then
		selSlot = 4
	elseif invKeyCheck == 5 and selSlot ~=5 then
		selSlot = 5
	end

	if self.Enabled then
		if self.inventoryOpen then
			color(75,75,75,100)
			rect("fill",65,25,645,505) --inventory background
			for i,v in pairs(invSlots) do
				if aabb(mouse,v) then
					color(red)
					rect('fill',v.x,v.y,v.size,v.size)
				end
				color(white)
				rect('line',v.x,v.y,v.size,v.size)
			end
		end

		color(125,125,125,125)
		rect("fill",self.hotbarSlots[selSlot].x,self.hotbarSlots[selSlot].y,self.hotbarSlots[selSlot].size,self.hotbarSlots[selSlot].size)
		color(white)
		for i,v in pairs(self.hotbarSlots) do
			rect("line",v.x,v.y,v.size,v.size)
			if v.img then
				draw(tileset,v.img,v.x+3.5,v.y+3.5)
			end
		end
	end
end