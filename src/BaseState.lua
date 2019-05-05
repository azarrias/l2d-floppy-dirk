-- Base class for all states which will be inherited by the actual game states
-- StateMachine requires each State have this set of methods
BaseState = Class{}

function BaseState:init() end
function BaseState:enter() end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end