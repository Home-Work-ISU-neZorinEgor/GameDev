local love = require "love"
local Pig = {}
Pig.__index = Pig

local config = require "config" 

function Pig:new(x, y)
    local pig = {}
    setmetatable(pig, Pig)

    pig.x = x
    pig.y = y
    pig.radius = 20
    pig.image = love.graphics.newImage(config.images.pig) -- да, у меня картинки лежат в конфиге....

    return pig
end

function Pig:draw()
    love.graphics.setColor(1, 1, 1, 1) 
    love.graphics.draw(self.image, self.x, self.y, nil, nil, nil, self.image:getWidth() / 2, self.image:getHeight() / 2) -- центрорование
end

return Pig
