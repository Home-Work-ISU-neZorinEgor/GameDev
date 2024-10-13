local love = require "love"
local Game = require "game"
local game

function love.load()
    game = Game:new()
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    love.graphics.setColor(1, 1, 1, 1)
    game:draw()
end

function love.mousepressed(x, y, button)
    game:mousepressed(x, y, button)
end

function love.mousemoved(x, y, dx, dy)
    game:mousemoved(x, y, dx, dy)
end

function love.keypressed(key)
    game:keypressed(key)
end
