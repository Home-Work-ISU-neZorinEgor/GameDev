-- block.lua
local Block = {}
Block.__index = Block

-- Конструктор блока
function Block.new(x, y, width, height, health)
    local block = setmetatable({}, Block)
    block.x = x
    block.y = y
    block.width = width
    block.height = height
    block.health = health  -- Прочность блока
    block.maxHealth = health  -- Максимальная прочность для отображения
    block.isDestroyed = false
    return block
end

-- Функция для обновления блока
function Block:update(bird)
    -- Проверка столкновения с птицей
    if not self.isDestroyed and bird.x + bird.size > self.x and bird.x < self.x + self.width and bird.y + bird.size > self.y and bird.y < self.y + self.height then
        -- Если блок не разрушен, проверим его прочность
        if bird.dx^2 + bird.dy^2 > 137321 then  -- Если скорость птицы достаточна для разрушения
            self.health = self.health - 1  -- Уменьшаем прочность
        end

        -- Если прочность блока 0, блок разрушен
        if self.health <= 0 then
            self.isDestroyed = true  -- Блок разрушен
            
            -- Логика замедления птички
            local slowFactor = 0.8  -- Коэффициент замедления (например, 80% от текущей скорости)
            bird.dx = bird.dx * slowFactor
            bird.dy = bird.dy * slowFactor
        else
            -- Отскакивание птички от блока
            -- Определяем сторону, с которой произошло столкновение, и меняем направление скорости птички
            if bird.y + bird.size > self.y and bird.y < self.y + self.height then
                -- Столкновение по вертикали (птичка сверху или снизу)
                bird.dy = -bird.dy  -- Отражаем скорость по вертикали
            end

            if bird.x + bird.size > self.x and bird.x < self.x + self.width then
                -- Столкновение по горизонтали (птичка слева или справа)
                bird.dx = -bird.dx  -- Отражаем скорость по горизонтали
            end
        end
    end
end


-- Функция для отрисовки блока
function Block:draw()
    if not self.isDestroyed then
        -- Цвет блока в зависимости от уровня здоровья
        if self.health == 3 then
            love.graphics.setColor(0.4, 0.8, 0.4)  -- Зеленый для здоровья 3
        elseif self.health == 2 then
            love.graphics.setColor(1, 1, 0)  -- Желтый для здоровья 2
        elseif self.health == 1 then
            love.graphics.setColor(1, 0, 0)  -- Красный для здоровья 1
        end
        
        -- Отображение прямоугольника
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

        -- Отображение оставшегося здоровья в формате [Осталось/Макс]
        love.graphics.setColor(1, 1, 1)  -- Белый цвет для текста
        love.graphics.print(string.format("[%d/%d]", self.health, self.maxHealth), self.x + 5, self.y + 5)
    end
end

return Block
