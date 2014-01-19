--##########################################################################################################################################--

--#######################################################[[  Player  }}#####################################################################--

--##########################################################################################################################################--
require "Ai.Creature" 

local keyCheck
local joyCheck = {Lr=false,Ll=false,Lu=false,Ld=false,a=false}
local keyDown = love.keyboard.isDown

Player = class("Player", Creature)

--##########################################################################################################################################--
function Player:initialize(name, x, y)
	--object variables
	self.name = name
	self.x = x
	self.y = y
	self.width = 24
	self.height = 32
	self.xvel = 0
	self.yvel = 0
	self.speed = 800
	self.friction = 2.5
	--helpful things
	self.player = true
	self.dt = 0
end

--##########################################################################################################################################--
function Player:update(dt)
	if joyConnected then 
		self:stick(dt)
	end
	self:move(dt)

	self.x = self.x + self.xvel * dt
	self.y = self.y + self.yvel * dt
	self.xvel = self.xvel * (1 - math.min(dt * self.friction, 1))
	self.yvel = self.yvel * (1 - math.min(dt * self.friction, 1))
end

--##########################################################################################################################################--
function Player:draw()
	color(red)
	rect("fill",self.x,self.y,self.width,self.height)
end

--##########################################################################################################################################--
function Player:move(dt)
	
	--movement

	--horizon
	if (keyDown("right")) or joyCheck.Lr then
		if self.xvel < self.speed then
			self.xvel = self.xvel + self.speed *dt
		end
	elseif (keyDown("left")) or joyCheck.Ll then  
		if self.xvel > -self.speed then
			self.xvel = self.xvel - self.speed*dt
		end
	end

	--vertical
	if (keyDown("up")) or joyCheck.Lu then
		if self.yvel > -self.speed then
			self.yvel = self.yvel - self.speed*dt
		end
	elseif (keyDown("down")) or joyCheck.Ld then  
		if self.yvel < self.speed then
			self.yvel = self.yvel + self.speed *dt
		end
	end


	--limit the speeds
	--x velocity
	if self.xvel >0 then
		self.xvel = math.floor(self.xvel)
	else
		self.xvel = math.ceil(self.xvel)
	end
	--y velocity
	if self.yvel >0 then
		self.yvel = math.floor(self.yvel)
	else
		self.yvel = math.ceil(self.yvel)
	end
	
end

--##########################################################################################################################################--
function Player:keyPressed(key)
	keyCheck = key
end

function Player:keyReleased(key)
	keyCheck = key
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