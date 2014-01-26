--##########################################################################################################################################--

--#######################################################[[  Game  }}#######################################################################--

--##########################################################################################################################################--
local SPgame = GameState:addState('Game')
doge = false
blocks = {}
--##########################################################################################################################################--
function SPgame:enteredState()
	
	require "Player"
	player = Player:new("Syca", 400, 300)
	blocks = {}
	require 'lib.camera'
	camera:setBounds(0, 0, 2000, 2000)
end

--##########################################################################################################################################--
function SPgame:update(dt)
	camera:setPosition((player.x+(player.size/2))-(800/2), (player.y+(player.size/2))-(600/2))
	Joystick = love.joystick.getJoysticks()[1]
	if Joystick ~= nil then
		joyConnected = Joystick:isConnected()
	end
	if #blocks >0 then
		for i,v in ipairs(blocks)do
			if aabb(player,blocks[i]) then
				collide(player,blocks[i])
			end
		end
	end
	player:update(dt)
	Timer.update(dt)
end

--##########################################################################################################################################--
function SPgame:draw()
	camera:set()

	color(150,150,0)
	rect("fill",200,100,400,200)
	
	for i,v in pairs(blocks) do
		color(v.color)
		rect("fill",v.x,v.y,v.size,v.size)
		color(white)
		rect("line",v.x,v.y,v.size,v.size)
	end
	
	player:draw()
	camera:unset()
	player:Interface()
	color(white)
	lg.print("FPS: "..love.timer.getFPS(),400,0)
	--lg.print("test: "..tostring(doge),400,10)
end

--##########################################################################################################################################--
function SPgame:keypressed(key, unicode)
	if key then
		player:keyPressed(key)
		doge = key
		if key == "escape" then
			love.event.quit()
		elseif key=="r"then
			self:pushState('Game')
		end
	end
	
end

--##########################################################################################################################################--
function SPgame:keyreleased(key)
	if key then
		player:keyReleased(key)

	end
end

--##########################################################################################################################################--

function checkDist(x1,y1,x2,y2)
	local dx = x1-x2
	local dy = y1-y2
	return math.sqrt((dx * dx + dy * dy))
end