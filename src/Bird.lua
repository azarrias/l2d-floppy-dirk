Bird = Class{}

local GRAVITY = 20
local JUMP_ACCELERATION = -5

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
  
  self.y = self.y + self.dy
end