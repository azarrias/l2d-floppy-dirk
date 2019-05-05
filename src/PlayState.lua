PlayState = Class{__includes = BaseState}

local SPAWN_PERIOD = 2
local SCORE_POS_OFFSET = 8

function PlayState:init()
  self.bird = Bird()
  self.pipePairs = {}
  self.spawnTimer = 0
  
  self.score = 0
  
  self.lastGapY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
  self.spawnTimer = self.spawnTimer + dt
  if self.spawnTimer > SPAWN_PERIOD then
    -- clamp the Y position of the pipes gap while transitioning smoothly from one to another
    local y = math.max(-PIPE_HEIGHT + 10, math.min(self.lastGapY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
    self.lastGapY = y
    table.insert(self.pipePairs, PipePair(y))
    self.spawnTimer = 0
  end
  
  for k, pipePair in pairs(self.pipePairs) do
    pipePair:update(dt)
  end
  
  for k, pipePair in pairs(self.pipePairs) do
    if pipePair.remove then
      table.remove(self.pipePairs, k)
    end
  end
  
  self.bird:update(dt)
  
  if self.bird.y >= VIRTUAL_HEIGHT - GROUND_HEIGHT then
    stateMachine:change('score', { 
      score = self.score 
    })
  end
    
  for i, pipePair in pairs(self.pipePairs) do
    -- score a point if the bird has gone past this pair of pipes
    if not pipePair.scored then
      if pipePair.x + PIPE_WIDTH < self.bird.x then
        self.score = self.score + 1
        pipePair.scored = true
      else
        -- otherwise, check each pipe for collisions
        for j, pipe in pairs(pipePair.pipes) do
          if self.bird:collides(pipe) then
            stateMachine:change('score', { 
              score = self.score 
            })
          end
        end   
      end
    end
  end
end

function PlayState:render()
  for k, pipePair in pairs(self.pipePairs) do
    pipePair:render()
  end
  
  love.graphics.setFont(bigFont)
  love.graphics.print('Score: ' .. tostring(self.score), SCORE_POS_OFFSET, SCORE_POS_OFFSET)
  
  self.bird:render()
end
