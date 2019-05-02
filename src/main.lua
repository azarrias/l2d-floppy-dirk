push = require 'libs.push'
Class = require 'libs.class'
require 'Bird'

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

local bird = Bird()

function love.load()
  -- use nearest-neighbor (point) filtering on upscaling and downscaling to prevent blurring of text and 
  -- graphics instead of the bilinear filter that is applied by default 
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.window.setTitle('Floppy Dirk')
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    vsync = true,
    fullscreen = false,
    resizable = true
  })
end

function love.resize(w, h)
  push:resize(w, h)
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end

function love.update(dt)
  backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_X
  groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
end

function love.draw()
  push:start()
  love.graphics.draw(background, -backgroundScroll, 0)
  love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - GROUND_HEIGHT)
  bird:render()
  push:finish()
end