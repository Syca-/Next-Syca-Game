Creature = class("Creature")

function Creature:initialize(name, x, y,width,height,image)
	self.name = name
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.xvel = 0
	self.yvel = 0
	self.speed = 0
	self.friction = 0
	self.dir = "Left"
	self.gravity = 0
	self.health = 128
	self.maxHP = 128
	self.damage = 25
	self.image=image
	self.dt = 0
end
function Creature:update(dt)
	self.dt = dt
	self:move(dt)

	self.x = self.x + self.xvel * dt
	self.y = self.y + self.yvel * dt
	self.xvel = self.xvel * (1 - math.min(dt * self.friction, 1))
	self.yvel = self.yvel  + self.gravity *dt
end

function Creature:render()
	color(75,0,200)
	rect('fill',self.x,self.y,self.width,self.height)
end