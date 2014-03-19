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
local invDone=false
local invSlots = {}
	for k=100,356,70 do
		for b=200,584,70 do
			table.insert(invSlots,{x=b,y=k,imagex=b+8.5,imagey=k+8.5,size=64,width=64,height=64,image=nil,func=nil,amount=nil,dura=nil})
		end
	end

Player = class("Player", Creature)

--##########################################################################################################################################--
function Player:initialize(name, x, y)
	--object variables
	self.name = name
	self.img =  love.graphics.newImage("art/player.png")
	self.img:setFilter("nearest","nearest")
	self.x = y
	self.y = x
	self.xvel =0
	self.yvel=0
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
	self.doorY = 0
	self.doorX=10
	self.hotbarSlots = {
		{x=340-36,y=550,size=32,func=function() self:breakBlock() end,img=items.hammer,item=true,amount=1,dura=102}, -- slot 1
		{x=380-36,y=550,size=32,func=function() self:place(nil,nil,true) end,img=tiles.door,block=true,amount=100}, -- slot 2 
		{x=420-36,y=550,size=32,func=function() self:place(nil,true) end,img=tiles.wall,block=true,amount=100}, -- slot 3
		{x=460-36,y=550,size=32,func=function() self:place(true) end,img=tiles.floor,block=true,amount=100}, -- slot 4
		{x=500-36,y=550,size=32,func=function() self:place(nil,nil,nil,true) end,img=tiles.window,block=true,amount=100} -- slot 5
	}
	self.following = false
	self.stopFollow=false
	self.followSlot = {}
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

	if self.xvel >0 then
		self.xvel = math.floor(self.xvel)
	else
		self.xvel = math.ceil(self.xvel)
	end
	if self.yvel >0 then
		self.yvel = math.floor(self.yvel)
	else
		self.yvel = math.ceil(self.yvel)
	end
	self.x=self.xvel
	self.y=self.yvel

	for i,v in pairs(self.hotbarSlots) do
		if v.img then
			if v.amount <=0 then
				v.img = nil
				v.amount =nil
				v.func = nil
			end
			if v.dura and v.dura <=0 then
				v.amount = 0
			end
		end
	end
end

--##########################################################################################################################################--
function Player:draw()
	color(white)
	draw(self.img,self.x,self.y)

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
			self.xvel = self.xvel + self.speed*dt
			self.anifacing = "east"
	elseif (keyDown("a"))then  
			self.xvel = self.xvel - self.speed*dt
			self.anifacing = "west"
	end
	
	--vertical
	if (keyDown("w"))then
		self.yvel = self.yvel - self.speed*dt
		self.anifacing = "north"

	elseif (keyDown("s"))then
		self.yvel = self.yvel + self.speed*dt
		self.anifacing = "south"
	end
	--placement control
	if (keyCheck=="up")then
			self.facing = "north"
			self.doorY = 0
			self.doorX=10
	elseif (keyCheck=="down")then
			self.facing = "south"
			self.doorY = 0
			self.doorX=10
	elseif (keyCheck=="right")then
			self.facing = "east"
			self.doorX=0
			self.doorY = 10
	elseif (keyCheck=="left")then
			self.facing = "west"
			self.doorX=0
			self.doorY = 10
	end

	for i,v in pairs(blocks)do
		if aabb(self.placer,blocks[i]) then
			if keyReseter=="e"then
				if v.door and v.doorOpen==false then
					Timer.add(.2,function() v.doorOpen= true end)
				elseif v.door and v.doorOpen then
					Timer.add(.2,function()v.doorOpen = false end)
				end
			end
		end
	end
	
end

--##########################################################################################################################################--
function Player:useHotbar(dt)
	if keyReseter==" "then
		if self.hotbarSlots[selSlot].func then
			self.hotbarSlots[selSlot].func()
		end
	end 
end

--##########################################################################################################################################--
function Player:place(floor,wall,door,window)
	if self.canPlace then
		if self.hotbarSlots[selSlot].amount < 99 then
			self.hotbarSlots[selSlot].amount=self.hotbarSlots[selSlot].amount-1
		end
		local block = {x=0,y=0,width = 24,height=24,size=24,door=door,doorOpen=false,floor=floor,wall=wall,window=window,doorX=self.doorX,doorY=self.doorY}

		block.y= self.gridy
		block.x = self.gridx
		table.insert(blocks,block)
	end
end

--##########################################################################################################################################--
function Player:breakBlock()

	for i,v in pairs(blocks)do
		if aabb(self.placer,blocks[i]) then
			table.remove(blocks,i)
			if self.hotbarSlots[selSlot].dura<101 then
				self.hotbarSlots[selSlot].dura=self.hotbarSlots[selSlot].dura-25
			end
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
	local invKeyCheck = 0
	
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
		if keyReseter =="y"then
			invSlots[10].image=tiles.wall
			invSlots[10].amount=25
		end
		if self.inventoryOpen then
			color(75,75,75,100)
			rect("fill",175,75,465,325) --inventory background
			for i,v in pairs(invSlots) do
				if v.followMouse then
					v.imagex=mouse.x
					v.imagey=mouse.y
					if self.stopFollow then
						v.image = nil
						v.amount = nil
						v.dura = nil
						v.func= nil
						v.followMouse=false
						v.imagex=self.followSlot.x
						v.imagey=self.followSlot.y
					end
				end
				if aabb(mouse,v) and v.followMouse ~= true then
					color(red)
					rect('fill',v.x,v.y,v.size,v.size)
					if click=='l' then
						if v.followMouse ~= true and self.following~=true then
							self.followSlot={image=v.image,amount=v.amount,dura=v.dura,func=v.func,x=v.imagex,y=v.imagey,previous=v}
							v.followMouse=true
							self.following = true
						elseif self.following and v.followMouse ~= true then
							v.image = self.followSlot.image
							v.amount = self.followSlot.amount
							v.dura = self.followSlot.dura
							v.func= self.followSlot.func
							if v ~= self.followSlot.previous then
								self.stopFollow = true
								self.following=false
							else
								self.stopFollow=false
							end
						end
					end
				end
				if v.image then
					color(white)
					draw(tileset,v.image,v.imagex,v.imagey,0,2,2)
					lg.print(v.amount,v.imagex+26,v.imagey+36)
				end
				color(white)
				rect('line',v.x,v.y,v.size,v.size)
			end
		end

		color(125,125,0,175)
		rect("fill",self.hotbarSlots[selSlot].x,self.hotbarSlots[selSlot].y,self.hotbarSlots[selSlot].size,self.hotbarSlots[selSlot].size)
		color(white)
		for i,v in pairs(self.hotbarSlots) do
			rect("line",v.x,v.y,v.size,v.size)
			if v.img then
				if v.block then
					draw(tileset,v.img,3.7+v.x,3.7+v.y)
					lg.print(v.amount,v.x+15-string.len(tostring(v.amount)),v.y+16)
				elseif v.item then
					draw(itemset,v.img,3.7+v.x,3.7+v.y)
					lg.print(v.dura,v.x+10,v.y+16)
				end
			end
		end
		color(white)
		lg.print("FPS: "..love.timer.getFPS(),400,0)
		lg.print(tostring(self.x),400,10)
	end
end