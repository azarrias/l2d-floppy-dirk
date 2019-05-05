PlayState = Class{__includes = BaseState}

local SPAWN_PERIOD = 2

function PlayState:init()
  self.bird = Bird()
  self.pipePairs = {}
  self.spawnTimer = 0
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
    stateMachine:change('title')
  end
    
  for i, pipePair in pairs(self.pipePairs) do    
    for j, pipe in pairs(pipePair.pipes) do
      if self.bird:collides(pipe) then
        -- for now just game over if bird collides with pipe
        stateMachine:change('title')
      end
    end
  end
end

function PlayState:render()
  for k, pipePair in pairs(self.pipePairs) do
    pipePair:render()
  end
  
  self.bird:render()
end
