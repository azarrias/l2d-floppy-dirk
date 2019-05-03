PipePair = Class{}

local GAP_HEIGHT = 90

function PipePair:init(y)
  self.x = VIRTUAL_WIDTH
  self.y = y
  
  self.pipes = {
    ['upper'] = Pipe('top', self.y),
    ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
  }
  
  self.remove = false
end

function PipePair:update(dt)
  if self.x + PIPE_WIDTH > 0 then
    self.x = self.x - PIPE_SCROLL_SPEED * dt
    self.pipes['lower'].x = self.x
    self.pipes['upper'].x = self.x
  else
    self.remove = true
  end
end

function PipePair:render()
  for k, pipe in pairs(self.pipes) do
    pipe:render()
  end
end