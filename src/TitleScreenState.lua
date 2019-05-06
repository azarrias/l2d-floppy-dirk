-- Child class that inherits from BaseState
TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:update(dt)
  if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] then
    stateMachine:change('countdown')
  end
end

function TitleScreenState:render()
  love.graphics.setFont(bigFont)
  love.graphics.printf(GAME_TITLE, 0, 64, VIRTUAL_WIDTH, 'center')
  love.graphics.setFont(mediumFont)
  love.graphics.printf('Press Enter', 0, 100, VIRTUAL_WIDTH, 'center')
end
  