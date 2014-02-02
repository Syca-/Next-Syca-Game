--##########################################################################################################################################--

--#######################################################[[  Game  }}#######################################################################--

--##########################################################################################################################################--
local SPgame = GameState:addState('Game')
grid = {x={},y={}}
local gridON = false
local keyReseter
mouse={width=1,height=1}
tileset = love.graphics.newImage("art/tileset.png")
tileset:setFilter("nearest","nearest")
tiles={
	wall=love.graphics.newQuad(24,0,24,24,48,48),
	door=love.graphics.newQuad(0,0,24,24,48,48),
	floor=love.graphics.newQuad(0,24,24,24,48,48),
	temp=love.graphics.newQuad(24,24,24,24,48,48)
}
--##########################################################################################################################################--
function SPgame:enteredState()
	for i=0,2400,24 do
		table.insert(grid.x,i)
		table.insert(grid.y,i)
	end
	blocks={}
	require "Player"
	player = Player:new("Syca", 0, 0)
	require 'lib.camera'
	camera:setBounds(0, 0, 2400, 2400)
end

--##########################################################################################################################################--
function SPgame:update(dt)
	mouse.x,mouse.y=love.mouse.getPosition()
	Joystick = love.joystick.getJoysticks()[1]
	camera:setPosition(player.x-(800/2),player.y-(600/2))
	if Joystick ~= nil then
		joyConnected = Joystick:isConnected()
	end
	
	for i,v in pairs(grid.x) do
		for i,k in pairs(grid.y)do
			if aabb(player.placer,{x=v,y=k,width=24,height=24}) then
				player.canPlace = true
				player.gridx = v
				player.gridy = k
			end
		end
	end
	for i,v in pairs(blocks)do
		if aabb(player.placer,v) then
			player.canPlace = false
		end
		if v.doorOpen==false and v.floor==nil then
			collide(player,v)
		end
	end
	player:update(dt)
	Timer.update(dt)
end

--##########################################################################################################################################--
function SPgame:draw()
	camera:set()
	for i,v in pairs(blocks) do
		if v.floor then
			color(v.color)
			rect("fill",v.x,v.y,v.size,v.size)
		elseif v.wall then
			color(v.color)
			rect("fill",v.x,v.y,v.size,v.size)
			color(white)
			rect("line",v.x,v.y,v.size,v.size)
		elseif v.door then
			if v.doorOpen then
				color(102,51,0,200)
				rect("fill",v.x,v.y,v.size,v.size)
				color(white)
				rect("line",v.x,v.y,v.size,v.size)
			elseif v.doorOpen == false then
				color(v.color)
				rect("fill",v.x,v.y,v.size,v.size)
				color(white)
				rect("line",v.x,v.y,v.size,v.size)
			end
		end
	end
	
	player:draw()
	color(white)
	if gridON then
		for i,v in pairs(grid.x) do
			rect("fill",0,v,2400,1)
			rect("fill",v,0,1,2400)
		end
	end
	camera:unset()

	player:Interface()

	--test stuff
	color(white)

	lg.print("FPS: "..love.timer.getFPS(),400,0)
	--lg.print("keys: "..tostring(keyReseter),400,10)
end

--##########################################################################################################################################--
function SPgame:keypressed(key)
	if key then
		keyReseter = key
		player:keyPressed(keyReseter)
		if keyReseter == "escape" then
			love.event.quit()
		elseif keyReseter=="r"then
			self:pushState('Game')
		elseif keyReseter=="f2"then
			if gridON then
				gridON = false
			elseif gridON == false then
				gridON = true
			end
		elseif keyReseter=="f1"then
			if player.Enabled then
				player.Enabled = false
			elseif player.Enabled == false then
				player.Enabled = true
			end
		elseif keyReseter =="i" or keyReseter =="b" then
			if player.inventoryOpen then
				player.inventoryOpen=false
			elseif player.inventoryOpen==false then
				player.inventoryOpen=true
			end
		end
	end
	
end

--##########################################################################################################################################--
function SPgame:keyreleased(key)
	if key then
		if keyReseter==key then
			keyReseter = nil
		end
		player:keyReleased(key)
	end
end