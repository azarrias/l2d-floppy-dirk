Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('assets/pipe.png')
local PIPE_SCROLL_SPEED = 60

function Pipe:init()
  self.x = VIRTUAL_WIDTH
  self.y = math.random(VIRTUAL_HEIGHT / 4, 3 * VIRTUAL_HEIGHT / 4)
  self.width = PIPE_IMAGE:getWidth()
end

function Pipe:update(dt)
  self.x = self.x - PIPE_SCROLL_SPEED * dt
end

function Pipe:render()
  love.graphics.draw(PIPE_IMAGE, self.x, self.y)
end