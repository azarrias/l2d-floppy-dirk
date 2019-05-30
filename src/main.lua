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

MOBILE_OS = (love._version_major > 0 or love._version_minor >= 9) and (love.system.getOS() == 'Android' or love.system.getOS() == 'OS X')
WEB_OS = (love._version_major > 0 or love._version_minor >= 9) and love.system.getOS() == 'Web'

WINDOW_WIDTH, WINDOW_HEIGHT = 1280, 720
VIRTUAL_WIDTH, VIRTUAL_HEIGHT = 512, 288
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
local NEW_COLOR_RANGE = love._version_major > 0 or love._version_major == 0 and love._version_minor >= 11

-- Wrapper functions to handle differences across love2d versions
local setColor = function(r, g, b, a)
  if not r or not g or not b or 
    not tonumber(r) or not tonumber(g) or not tonumber(b) 
    or a and not tonumber(a) then
    error("bad argument to 'setColor' (number expected)")
  end
  a = a or 255
  if NEW_COLOR_RANGE then
    love.graphics.setColor(r/255, g/255, b/255, a/255)
  else
    love.graphics.setColor(r, g, b, a)
  end
end

local clear = function(r, g, b, a, clearstencil, cleardepth)
  if not r or not g or not b or 
    not tonumber(r) or not tonumber(g) or not tonumber(b) 
    or a and not tonumber(a) then
    error("bad argument to 'clear' (number expected)")
  end
  a, clearstencil, cleardepth = a or 255, clearstencil or true, cleardepth or true
  if NEW_COLOR_RANGE then
    love.graphics.clear(r/255, g/255, b/255, a/255, clearstencil, cleardepth)
  else
    love.graphics.clear(r, g, b, a)
  end
end

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  -- use nearest-neighbor (point) filtering on upscaling and downscaling to prevent blurring of text and 
  -- graphics instead of the bilinear filter that is applied by default 
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.window.setTitle(GAME_TITLE)
  math.randomseed(os.time())

  smallFont = love.graphics.newFont('assets/font.ttf', 8)  
  if WEB_OS then
    mediumFont = love.graphics.newFont('assets/font.ttf', 14)
    bigFont = love.graphics.newFont('assets/font.ttf', 28)
    hugeFont = love.graphics.newFont('assets/font.ttf', 56)
  else
    mediumFont = love.graphics.newFont('assets/flappy.ttf', 14)
    bigFont = love.graphics.newFont('assets/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('assets/flappy.ttf', 56)
  end
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
    fullscreen = MOBILE_OS,
    resizable = not MOBILE_OS
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

function love.touchpressed(id, x, y, dx, dy, pressure)
  love.keyboard.keysPressed['enter'] = true
  love.keyboard.keysPressed['space'] = true
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
