Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('assets/pipe.png')
PIPE_SCROLL_SPEED = 60
PIPE_HEIGHT = PIPE_IMAGE:getHeight()
PIPE_WIDTH = PIPE_IMAGE:getWidth()

function Pipe:init(orientation, y)
  self.x = VIRTUAL_WIDTH
  self.y = y
  self.width = PIPE_WIDTH
  self.height = PIPE_HEIGHT
  self.orientation = orientation
end

function Pipe:update(dt)
  self.x = self.x - PIPE_SCROLL_SPEED * dt
end

function Pipe:render()
  love.graphics.draw(PIPE_IMAGE, self.x, 
    self.orientation == 'top' and self.y + self.height or self.y,
    0, -- rotation
    1, -- X scale
    self.orientation == 'top' and -1 or 1) -- Y scale
end