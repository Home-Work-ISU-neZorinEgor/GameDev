local Pig = {}
Pig.__index = Pig

-- Конструктор свинки
function Pig.new(x, y, size)
    local pig = setmetatable({}, Pig)
    pig.x = x
    pig.y = y
    pig.size = size
    pig.hit = false
    return pig
end

-- Функция для обновления свинки
function Pig:update(bird)
    if not self.hit and
        bird.x + bird.size > self.x and
        bird.x < self.x + self.size and
        bird.y + bird.size > self.y and
        bird.y < self.y + self.size then
        self.hit = true
    end
end

-- Функция для отрисовки свинки
function Pig:draw()
    if not self.hit then
        love.graphics.setColor(0, 1, 0)
    else
        love.graphics.setColor(0.5, 0.5, 0.5)
    end
    love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
end

return Pig
