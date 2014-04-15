--##########################################################################################################################################--

--#######################################################[[  Game  }}#######################################################################--

--##########################################################################################################################################--
local SPgame = GameState:addState('Game')
require "Blocks.Blocks"
require "Items.Items"
grid = {x={},y={}}
keyReseter = nil
click = nil
mouse={width=1,height=1}

--##########################################################################################################################################--
function SPgame:enteredState()
	for i=0,2400,24 do
		table.insert(grid.x,i)
		table.insert(grid.y,i)
	end
	floors={}
	doors={}
	walls = {}
	require "Player.Player"
	player = Player:new(0, 0)
	require "Player.GUI"
	gui = GUI:new()

	require 'lib.camera'
	camera:setBounds(0, 0, 2400, 2400)
end

--##########################################################################################################################################--
function SPgame:update(dt)
	--require("lib/lurker").update()
	mouse.x,mouse.y=love.mouse.getPosition()

	camera:setPosition((player.x+(player.size/2))-(800/2),(player.y+(player.size/2))-(600/2))
	
	player:update(dt)
	gui:update(dt)
	Timer.update(dt)
end

--##########################################################################################################################################--
function SPgame:draw()
	camera:set()
	--draw order
	--floors
	--doors
	--player
	--walls
	
	player:draw()
	camera:unset()
	gui:draw()
end

--##########################################################################################################################################--
function SPgame:keypressed(key)
	if key then
		keyReseter = key
		if keyReseter == "escape" then
			love.event.quit()
		elseif keyReseter=="r"then
			self:pushState('Game')
		end
	end
	
end

--##########################################################################################################################################--
function SPgame:keyreleased(key)
	if key then
		if keyReseter==key then
			keyReseter = nil
		end
	end
end

--##########################################################################################################################################--
function SPgame:mousepressed(x, y, button)
	if button then
		click = button
	end
end

--##########################################################################################################################################--
function SPgame:mousereleased(x, y, button)
	if button then
		if click == button then
			click = nil
		end
	end
end