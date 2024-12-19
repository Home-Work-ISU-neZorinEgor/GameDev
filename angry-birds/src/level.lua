-- level.lua

-- Параллакс:

-- 1. Фон движется с разной скоростью: Параметр speedX в объекте background определяет, насколько медленно или быстро фон двигается по оси X относительно камеры. Чем меньше значение, тем медленнее движется фон, создавая эффект удаленности.
-- 2. Зацикливание фона: Фон рисуется дважды с координатами, основанными на позиции камеры, что позволяет фону зацикливаться по оси X (когда он выходит за экран, он снова появляется с другой стороны).
-- 3. Эффект глубины: Когда камера движется, фон перемещается с меньшей скоростью, чем объекты на переднем плане (например, птица), создавая ощущение глубины.

local json = require("libs.json") -- Библиотека для работы с JSON
local Pig = require("pig")
local Block = require("block")

local Level = {}
Level.__index = Level

function Level.new(bird, ground, camera, pigs, blocks, background, birdsCount)
    local level = setmetatable({}, Level)
    level.bird = bird
    level.ground = ground
    level.camera = camera
    level.pigs = pigs or {}
    level.blocks = blocks or {}
    level.background = background or nil  -- Добавляем фоновое изображение
    level.destroyedPigs = 0  -- Количество уничтоженных свиней
    level.destroyedBlocks = 0  -- Количество уничтоженных блоков
    level.remainingShots = birdsCount or 3  -- Количество оставшихся выстрелов, загружаем из JSON
    level.usedBirds = 0  -- Количество использованных птичек
    level.isGameOver = false  -- Флаг окончания игры
    return level
end

-- Метод загрузки уровня
function Level:load()
    self.bird.load()
    self.ground.load()
    self.camera.initialX = self.camera.x
    self.camera.initialY = self.camera.y

    -- Загрузка фона
    if self.background then
        self.background.image = love.graphics.newImage(self.background.imagePath)
        self.background.width = self.background.image:getWidth()
        self.background.height = self.background.image:getHeight()
    end
end

function Level:reset()
    self.camera.x = 0
    self.camera.y = 0
    self:load()
    self.remainingShots = self.birdCount or 3  -- Сбрасываем количество выстрелов на значение из JSON
    self.usedBirds = 0  -- Сбрасываем количество использованных птичек
    self.destroyedPigs = 0  -- Сбрасываем уничтоженные свиней
    self.destroyedBlocks = 0  -- Сбрасываем уничтоженные блоки
    self.isGameOver = false  -- Сбрасываем флаг окончания игры
end

-- Метод обновления уровня
function Level:update(dt)
    if self.isGameOver then
        return  -- Прекращаем обновление, если игра окончена
    end

    self.bird.update(dt)

    for _, pig in ipairs(self.pigs) do
        pig:update(self.bird)
    end

    for _, block in ipairs(self.blocks) do
        block:update(self.bird)
    end

    if self.bird.isLaunched and (self.bird.dx ~= 0 or self.bird.dy ~= 0) then
        self.camera.setFollowMode(true)
        local cameraY = self.bird.y + self.bird.size / 2
        
        -- Ограничиваем движение камеры по оси Y
        cameraY = math.max(300, math.min(300, cameraY))
        
        self.camera.setPosition(self.bird.x + self.bird.size / 2, cameraY)
    else
        self.camera.setFollowMode(false)
    end

    -- Обновляем камеру
    self.camera.update(dt)

    -- Проверка на завершение игры (когда использованы все выстрелы)
    if self.remainingShots <= 0 and not self.isGameOver then
        self.isGameOver = true  -- Игра завершена
    end
end

-- Метод для обработки нажатий мыши
function Level:mousepressed(x, y, button)
    self.bird.mousepressed(x, y, button)
end

-- Метод для обработки отпускания кнопки мыши
function Level:mousereleased(x, y, button)
    if self.isGameOver then
        return  -- Если игра окончена, не разрешаем делать выстрел
    end

    if self.remainingShots > 0 then
        self.bird.mousereleased(x, y, button)
        if self.bird.isLaunched then
            -- Если выстрел был сделан, уменьшаем количество выстрелов
            self.remainingShots = self.remainingShots - 1
            self.usedBirds = self.usedBirds + 1  -- Увеличиваем количество использованных птичек
        end
    end
end

-- Метод отрисовки уровня
function Level:draw()
    self.camera.apply()

    -- Отрисовываем параллаксный фон, зацикленный по оси X
    if self.background then
        local backgroundX = (self.camera.x * self.background.speedX) % self.background.width
        
        -- Рассчитываем сколько раз нужно нарисовать фон, чтобы он полностью покрывал экран
        local numRepeats = 20
        
        -- Рисуем фон бесконечно
        for i = 0, numRepeats - 1 do
            love.graphics.draw(self.background.image, -5 * backgroundX + i * self.background.width, 0)
        end
    end

    self.ground.draw()
    self.bird.draw()

    for _, pig in ipairs(self.pigs) do
        pig:draw()
    end

    for _, block in ipairs(self.blocks) do
        block:draw()
    end

    -- Вывод статистики
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Remaining Shots: " .. self.remainingShots, 10, 10)

    if self.isGameOver then
        -- Выводим статистику после завершения игры
        self.camera:resetPosition()
        love.graphics.print("Game Over!", 400, 200)
        love.graphics.print("Destroyed Blocks: " .. self.destroyedBlocks, 400, 220)
        love.graphics.print("Used Birds: " .. self.usedBirds, 400, 240)
        love.graphics.print("Destroyed Pigs: " .. self.destroyedPigs, 400, 260)

    end

    self.camera.reset()
end

-- Загрузка уровня из JSON
function Level.fromJson(jsonData, bird, ground, camera)
    local data = json.decode(jsonData)
    local pigs = {}
    local blocks = {}

    for _, pigData in ipairs(data.pigs or {}) do
        table.insert(pigs, Pig.new(pigData.x, pigData.y, pigData.size))
    end

    for _, blockData in ipairs(data.blocks or {}) do
        table.insert(blocks, Block.new(blockData.x, blockData.y, blockData.width, blockData.height, blockData.type))
    end

    -- Загрузка данных о фоне
    local background = {
        imagePath = data.background and data.background.imagePath or nil,
        speedX = data.background and data.background.speedX or 0.5,
    }

    -- Загружаем количество птичек из JSON
    local birdsCount = data.birdsCount or 3  -- Если поле не указано, используем 3 птички по умолчанию

    return Level.new(bird, ground, camera, pigs, blocks, background, birdsCount)
end

-- Метод для обработки нажатий клавиш
function Level:keypressed(key)
    if key == "r" then
        self:reset()  -- Вызываем метод перезапуска уровня
    end
end

return Level
