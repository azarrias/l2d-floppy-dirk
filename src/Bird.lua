Bird = Class{}

local GRAVITY = 500
local JUMP_ACCELERATION = -200
local COLLISION_OFFSET = 8

function Bird:init()
  self.image = love.graphics.newImage('assets/bird.png')
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
  self.x = VIRTUAL_WIDTH / 2 - self.width / 2
  self.y = VIRTUAL_HEIGHT / 2 - self.height / 2
  self.dy = 0
end

function Bird:render()
  love.graphics.draw(self.image, self.x, self.y)
end

function Bird:update(dt)
  self.dy = self.dy + GRAVITY * dt
  
  if love.keyboard.keysPressed['space'] then
    self.dy = JUMP_ACCELERATION
  end
  
  self.y = math.floor(self.y + self.dy * dt + 0.5)
end

-- AABB collision
function Bird:collides(pipe)
  if self.x - COLLISION_OFFSET + self.width >= pipe.x and self.x + COLLISION_OFFSET <= pipe.x + pipe.width then
    if self.y - COLLISION_OFFSET + self.height >= pipe.y and self.y + COLLISION_OFFSET <= pipe.y + pipe.height then
      return true
    end
  end
  
  return false
end