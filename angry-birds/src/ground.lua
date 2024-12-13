-- ground.lua
local ground = {x = -6000, y = 900, width = 18000, height = 20}
local groundImage

function ground.load()
    -- Загружаем изображение для земли
    groundImage = love.graphics.newImage("asserts/images/ground.png")  -- Убедитесь, что у вас есть изображение
end

function ground.draw()
    -- Рисуем изображение земли, растягивая его по ширине
    love.graphics.draw(groundImage, ground.x, ground.y, 0, ground.width / groundImage:getWidth(), ground.height / groundImage:getHeight())
end

return ground
