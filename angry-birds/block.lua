local love = require "love"
local Block = {}
Block.__index = Block

local config = require "config"

function Block:new(x, y, width, height)
    local block = {}
    setmetatable(block, Block)

    block.x = x
    block.y = y
    block.width = width
    block.height = height
    block.image = love.graphics.newImage(config.images.block) -- Загрузка изображения блока
    block.isDestroyed = false -- Флаг для разрушенного блока

    return block
end

function Block:draw()
    if not self.isDestroyed then
        love.graphics.draw(self.image, self.x, self.y)
    end
end

function Block:update(dt, bird)
    if not self.isDestroyed then
        -- Проверка разрушения блока при столкновении с птицей
        local dx = bird.x - (self.x + self.width / 2)
        local dy = bird.y - (self.y + self.height / 2)
        local distance = math.sqrt(dx * dx + dy * dy)

        if distance < (bird.radius + math.min(self.width, self.height) / 2) then
            self.isDestroyed = true -- Разрушаем блок
        end
    end
end

return Block
