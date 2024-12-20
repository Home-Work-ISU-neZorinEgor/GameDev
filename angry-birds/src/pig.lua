local Pig = {}
Pig.__index = Pig

-- Конструктор свинки
function Pig.new(x, y, size)
    local pig = setmetatable({}, Pig)
    pig.x = x
    pig.y = y
    pig.size = size
    pig.hit = false
    pig.soundPlayed = false  -- Добавляем флаг для отслеживания воспроизведения звука
    return pig
end

-- Функция для обновления свинки
function Pig:update(bird)
    -- Проверка на столкновение с птичкой
    if not self.hit and
        bird.x + bird.size > self.x and
        bird.x < self.x + self.size and
        bird.y + bird.size > self.y and
        bird.y < self.y + self.size then
        self.hit = true  -- Отметить, что свинка задетая
        return true  -- Возвращаем true, если свинка была задетая
    end
    return false  -- Если свинка не была задетая
end

-- Функция для отрисовки свинки
function Pig:draw()
    -- Проверяем, был ли уже проигран звук
    if not self.hit then
        love.graphics.setColor(0, 1, 0)
    else
        love.graphics.setColor(0.5, 0.5, 0.5)

        -- Если звук еще не был проигран, проигрываем его и устанавливаем флаг
        if not self.soundPlayed then
            local sound = love.audio.newSource("asserts/sounds/pig_death.mp3", "static")
            sound:play()
            self.soundPlayed = true  -- Устанавливаем флаг, что звук был проигран
        end
    end
    love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
end

return Pig
