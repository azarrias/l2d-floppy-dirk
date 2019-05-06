push = require 'libs.push'
Class = require 'libs.class'
require 'Bird'
require 'Pipe'
require 'PipePair'
require 'StateMachine'
require 'BaseState'
require 'CountdownState'
require 'PlayState'
require 'TitleScreenState'
require 'ScoreState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288
GROUND_HEIGHT = 16
GAME_TITLE = 'Floppy Dirk'

-- local variable; won't be accessible outside from this file
local background = love.graphics.newImage('assets/background.png')
local backgroundScroll = 0
local ground = love.graphics.newImage('assets/ground.png')
local groundScroll = 0
local BACKGROUND_SCROLL_SPEED = 30
local BACKGROUND_LOOPING_X = 413
local GROUND_SCROLL_SPEED = 60

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  -- use nearest-neighbor (point) filtering on upscaling and downscaling to prevent blurring of text and 
  -- graphics instead of the bilinear filter that is applied by default 
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.window.setTitle(GAME_TITLE)
  math.randomseed(os.time())
  
  smallFont = love.graphics.newFont('assets/font.ttf', 8)
  mediumFont = love.graphics.newFont('assets/flappy.ttf', 14)
  bigFont = love.graphics.newFont('assets/flappy.ttf', 28)
  hugeFont = love.graphics.newFont('assets/flappy.ttf', 56)
  love.graphics.setFont(bigFont)
  
  sounds = {
    ['jump'] = love.audio.newSource('assets/jump.wav', 'static'),
    ['explosion'] = love.audio.newSource('assets/explosion.wav', 'static'),
    ['hurt'] = love.audio.newSource('assets/hurt.wav', 'static'),
    ['score'] = love.audio.newSource('assets/score.wav', 'static'),
    ['music'] = love.audio.newSource('assets/marios_way.mp3', 'stream')
  }
  
  sounds['music']:setLooping(true)
  sounds['music']:play()
  
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    vsync = true,
    fullscreen = false,
    resizable = true
  })

  stateMachine = StateMachine {
    ['title'] = function() return TitleScreenState() end,
    ['countdown'] = function() return CountdownState() end,
    ['play'] = function() return PlayState() end,
    ['score'] = function() return ScoreState() end
  }
  stateMachine:change('title')
  
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
  backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_X
  groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
  
  stateMachine:update(dt)
  
  -- reset input table
  love.keyboard.keysPressed = {}
end

function love.draw()
  push:start()
  love.graphics.draw(background, -backgroundScroll, 0)
  
  stateMachine:render()
  
  love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - GROUND_HEIGHT)
  push:finish()
end