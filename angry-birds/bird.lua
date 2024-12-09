local love = require "love"
local Bird = {}
Bird.__index = Bird

local config = require "config"

function Bird:new(slingshot)
    local bird = {}
    setmetatable(bird, Bird)

    bird.x = slingshot.x
    bird.y = slingshot.y
    bird.radius = 20
    bird.vx = 0
    bird.vy = 0
    bird.isHeld = true
    bird.image = love.graphics.newImage(config.images.bird) 
    return bird
end

function Bird:update(dt, gravity, isFlying)
    -- Добавьте условие для столкновения с землей
    if self.y + self.radius >= love.graphics.getHeight() - 50 then  -- Допустим, земля на высоте 50 пикселей от низа экрана
        self.vy = 0  -- Останавливаем вертикальную скорость
        self.y = love.graphics.getHeight() - self.radius  -- Устанавливаем птицу на уровне земли
    else
        -- Если птичка не на земле, применяем гравитацию
        self.vy = self.vy + gravity * dt
    end

    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
end


function Bird:checkGroundCollision(groundY)
    if self.y + self.radius >= groundY then
        self.y = groundY - self.radius
        self.vy = self.vy * 0.5 -- Уменьшаем вертикальную скорость при столкновении

        -- TODO: потом переделаю
        if math.abs(self.vy) < 10 then
            self.vy = 0
        end

        return false -- Птица больше не летает
    end
    return true -- Птица всё ещё летит
end

function Bird:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.image, self.x, self.y, nil, nil, nil, self.image:getWidth() / 2, self.image:getHeight() / 2) -- Центрируем изображение
end

return Bird
