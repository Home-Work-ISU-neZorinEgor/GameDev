-- main.lua

local game = require("game")

function love.load()
    love.window.setMode(1920, 1080)
    game.load()
end

function love.update(dt)
    game.update(dt)
end

function love.keypressed(key)
    game.keypressed(key)
end

function love.mousepressed(x, y, button)
    game.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    game.mousereleased(x, y, button)
end

function love.draw()
    game.draw()
end
