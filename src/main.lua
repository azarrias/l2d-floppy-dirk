push = require 'libs.push'
Class = require 'libs.class'
require 'Bird'
require 'Pipe'
require 'PipePair'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288
GROUND_HEIGHT = 16

-- local variable; won't be accessible outside from this file
local background = love.graphics.newImage('assets/background.png')
local backgroundScroll = 0
local ground = love.graphics.newImage('assets/ground.png')
local groundScroll = 0
local BACKGROUND_SCROLL_SPEED = 30
local BACKGROUND_LOOPING_X = 413
local GROUND_SCROLL_SPEED = 60
local SPAWN_PERIOD = 2

local bird = Bird()
local pipePairs = {}
local spawnTimer = 0
local lastGapY = -PIPE_HEIGHT + math.random(80) + 20
local scrolling = true

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  -- use nearest-neighbor (point) filtering on upscaling and downscaling to prevent blurring of text and 
  -- graphics instead of the bilinear filter that is applied by default 
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.window.setTitle('Floppy Dirk')
  math.randomseed(os.time())
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    vsync = true,
    fullscreen = false,
    resizable = true
  })
  -- global table to keep track of keys that are being pressed
  love.keyboard.keysPressed = {}
end

function love.resize(w, h)
  push:resize(w, h)
end

function love.keypressed(key)
  love.keyboard.keysPressed[key] = true
  if key == 'escape' then
    love.event.quit()
  end
end

function love.update(dt)
  if scrolling then
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_X
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
    
    spawnTimer = spawnTimer + dt
    if spawnTimer > SPAWN_PERIOD then
      -- clamp the Y position of the pipes gap while transitioning smoothly from one to another
      local y = math.max(-PIPE_HEIGHT + 10, math.min(lastGapY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
      lastGapY = y
      table.insert(pipePairs, PipePair(y))
      spawnTimer = 0
    end
    
    bird:update(dt)
    
    for k, pipePair in pairs(pipePairs) do
      pipePair:update(dt)
      
      for l, pipe in pairs(pipePair.pipes) do
        if bird:collides(pipe) then
          -- pause game to show collision
          scrolling = false
        end
      end
    end
    
    for k, pipePair in pairs(pipePairs) do
      if pipePair.remove then
        table.remove(pipePairs, k)
      end
    end
  end
  
  -- reset input table
  love.keyboard.keysPressed = {}
end

function love.draw()
  push:start()
  love.graphics.draw(background, -backgroundScroll, 0)
  
  for k, pipePair in pairs(pipePairs) do
    pipePair:render()
  end
  
  love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - GROUND_HEIGHT)
  bird:render()
  push:finish()
end