-- ground.lua
local ground = {x = -6000, y = 900, width = 9000, height = 20}

function ground.load()
    -- Можно добавить дополнительные параметры для земли, если потребуется
end

function ground.draw()
    love.graphics.setColor(0.4, 0.8, 0.4)
    love.graphics.rectangle("fill", ground.x, ground.y, ground.width, ground.height)
end

return ground
