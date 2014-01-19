
GameState = class('GameState'):include(Stateful)

--------------------------------------------------------------------------------
function GameState:initialize()
end

--------------------------------------------------------------------------------
function GameState:update(dt)
end

--------------------------------------------------------------------------------
function GameState:draw()
end

--------------------------------------------------------------------------------
function GameState:focus(f)
end

--------------------------------------------------------------------------------
function GameState:joystickpressed(joystick, button)
end

--------------------------------------------------------------------------------
function GameState:joystickreleased(joystick, button)
end

--------------------------------------------------------------------------------
function GameState:keypressed(key, unicode)
end

--------------------------------------------------------------------------------
function GameState:keyreleased(key)
end

--------------------------------------------------------------------------------
function GameState:mousepressed(x, y, button)
end

--------------------------------------------------------------------------------
function GameState:mousereleased(x, y, button)
end

--------------------------------------------------------------------------------
function GameState:quit()
end
