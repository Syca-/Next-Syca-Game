--##########################################################################################################################################--

--#######################################################[[  Player  }}#####################################################################--

--##########################################################################################################################################--
require "Ai.Creature" 

local keyCheck = 0
local keyReleasedCheck = 0
local numberCheck = 0
local joyCheck = {Lr=false,Ll=false,Lu=false,Ld=false,a=false}
local keyDown = love.keyboard.isDown
local selSlot = 1

Player = class("Player", Creature)

--##########################################################################################################################################--
function Player:initialize(name, x, y)
	--object variables
	self.name = name
	self.x = y
	self.y = x
	self.size=24
	self.width = self.size
	self.height = self.size
	self.speed = 6
	self.friction = 2.5
	self.facing = "north"
	--helpful things
	self.player = true
	self.dt = 0
	self.Enabled = true
end

--##########################################################################################################################################--
function Player:update(dt)
	if joyConnected then 
		self:stick(dt)
	end
	self:move(dt)
	self:useHotbar()

	if self.x <= 0 then
		self.x = 0
	elseif self.x >=2000 then
		self.x = 2000
	end
	if self.y <= 0 then
		self.y = 0
	elseif self.y >=2000 then
		self.y = 2000
	end
end

--##########################################################################################################################################--
function Player:draw()
	color(red)
	rect("fill",self.x,self.y,self.size,self.size)
	color(100,100,100)
	if self.facing == "west" then
		rect("line",self.x-self.size,self.y,self.size,self.size)
	elseif self.facing == "east"then
		rect("line",self.x+self.size,self.y,self.size,self.size)
	elseif self.facing == "north"then
		rect("line",self.x,self.y-self.size,self.size,self.size)
	elseif self.facing == "south"then
		rect("line",self.x,self.y+self.size,self.size,self.size)
	end
end

--##########################################################################################################################################--
function Player:move(dt)
	
	--movement

	--horizon
	if (keyDown("right")) or joyCheck.Lr and keyDown("lshift") ~= true then
			self.x = self.x + self.speed
			self.facing = "east"
	elseif (keyDown("left")) or joyCheck.Ll and keyDown("lshift") ~= true  then  
			self.x = self.x - self.speed
			self.facing = "west"
	end

	--vertical
	if (keyDown("up")) or joyCheck.Lu and keyDown("lshift") ~= true  then
			self.y = self.y - self.speed
			self.facing = "north"
	elseif (keyDown("down")) or joyCheck.Ld and keyDown("lshift") == false  then
			self.y = self.y + self.speed
			self.facing = "south"
	end
	if keyDown("down") and keyDown("lshift") then
		self.facing = "south"
	end
	
end

--##########################################################################################################################################--
function Player:useHotbar()
	local tes
	local invSlot = {function() self:place(red) end,function() self:place(green) end,function() self:place(blue) end,function() self:place({255,6,170}) end,function() self:place({155,60,255}) end}
	if keyDown(" ") then
		invSlot[selSlot]()
	end 
end

--##########################################################################################################################################--
function Player:place(color)
	local block = {x=0,y=0,width = 24,height=24,size=24,color=color}

	if self.facing == "east" then
		block.x = self.x+self.width
		block.y= self.y
		table.insert(blocks,block)
	elseif self.facing == "south" then
		block.y= self.y+self.height
		block.x = self.x
		table.insert(blocks,block)
	elseif self.facing == "west" then
		block.x = self.x-block.size
		block.y= self.y
		table.insert(blocks,block)
	elseif self.facing =="north" then
		block.y= self.y-block.size
		block.x = self.x
		table.insert(blocks,block)
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
	local invKeyCheck = 0
	local invSlot = {
		{x=340-36,y=550,size=32}, -- slot 1
		{x=380-36,y=550,size=32}, -- slot 2 
		{x=420-36,y=550,size=32}, -- slot 3
		{x=460-36,y=550,size=32}, -- slot 4
		{x=500-36,y=550,size=32} -- slot 5
	}
	if keyCheck == "f1" and self.Enabled then
		self.Enabled = false
	elseif keyCheck == "f1" and self.Enabled == false then
		self.Enabled = true
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
		
		color(125,125,125,125)
		rect("fill",invSlot[selSlot].x,invSlot[selSlot].y,invSlot[selSlot].size,invSlot[selSlot].size)
		color(white)
		for i,v in pairs(invSlot) do
			rect("line",v.x,v.y,v.size,v.size)
		end
	end
end