ScoreState = Class{__includes = BaseState}

function ScoreState:enter(params)
  self.score = params.score
end

function ScoreState:update(dt)
  -- go back to play state if enter is pressed
  if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] then
    stateMachine:change('countdown')
  end
end

function ScoreState:render()
  love.graphics.setFont(bigFont)
  love.graphics.printf('Ouch! that one hurt!', 0, 64, VIRTUAL_WIDTH, 'center')
  
  love.graphics.setFont(mediumFont)
  love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')
  
  if MOBILE_OS then
    love.graphics.printf('Tap on the screen to play again!', 0, 100, VIRTUAL_WIDTH, 'center')
  else
    love.graphics.printf('Press Enter to play again!', 0, 160, VIRTUAL_WIDTH, 'center')
  end
end