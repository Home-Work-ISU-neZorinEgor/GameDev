local Slingshot = {}
Slingshot.__index = Slingshot

function Slingshot.new(x, y)
    local slingshot = setmetatable({}, Slingshot)
    slingshot.x = x
    slingshot.y = y
    slingshot.width = 20
    slingshot.height = 400
    slingshot.color = {0.6, 0.4, 0.2}  -- Цвет для рогатки
    return slingshot
end

function Slingshot:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    -- love.graphics.rectangle("fill", self.x-self.x/4 + 10, self.y, 150, 20)
end

return Slingshot
