--##########################################################################################################################################--

--#######################################################[[  Player  }}#####################################################################--

--##########################################################################################################################################--
require "Ai.Creature" 

local keyDown = love.keyboard.isDown

Player = class("Player", Creature)

--##########################################################################################################################################--
function Player:initialize(x, y)
	--object variables
	self.health = 200
	self.mana = 200
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
	self.facing = "north"

end

--##########################################################################################################################################--
function Player:update(dt)
	self:move(dt)
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
end

--##########################################################################################################################################--
function Player:move(dt)
	
	--movement
	--horizon
	if (keyDown("d"))then
			self.xvel = self.xvel + self.speed*dt
			self.facing = "east"
	elseif (keyDown("a"))then  
			self.xvel = self.xvel - self.speed*dt
			self.facing = "west"
	end
	
	--vertical
	if (keyDown("w"))then
		self.yvel = self.yvel - self.speed*dt
		self.facing = "north"

	elseif (keyDown("s"))then
		self.yvel = self.yvel + self.speed*dt
		self.facing = "south"
	end
end

--##########################################################################################################################################--
function Player:draw()
	color(white)
	draw(self.img,self.x,self.y)
end