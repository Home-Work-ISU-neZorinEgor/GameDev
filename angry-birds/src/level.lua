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

function Level.new(bird, ground, camera, pigs, blocks, background)
    local level = setmetatable({}, Level)
    level.bird = bird
    level.ground = ground
    level.camera = camera
    level.pigs = pigs or {}
    level.blocks = blocks or {}
    level.background = background or nil  -- Добавляем фоновое изображение
    level.destroyedPigs = 0  -- Количество уничтоженных свиней
    level.destroyedBlocks = 0  -- Количество уничтоженных блоков
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

-- В классе Level добавьте метод reset
function Level:reset()
    self:load()  -- Перезагрузить уровень
    self.camera.x = self.camera.initialX
    self.camera.y = self.camera.initialY
end

-- Метод обновления уровня
function Level:update(dt)
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
end


-- Метод для обработки нажатий мыши
function Level:mousepressed(x, y, button)
    self.bird.mousepressed(x, y, button)
end

-- Метод для обработки отпускания кнопки мыши
function Level:mousereleased(x, y, button)
    self.bird.mousereleased(x, y, button)
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
            love.graphics.draw(self.background.image, -backgroundX + i * self.background.width, 0)
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

    self.camera.reset()
end



function Level.fromJson(jsonData, bird, ground, camera)
    local data = json.decode(jsonData)
    local pigs = {}
    local blocks = {}

    for _, pigData in ipairs(data.pigs or {}) do
        print("Pig coordinates:", pigData.x, pigData.y, "Size:", pigData.size)
        table.insert(pigs, Pig.new(pigData.x, pigData.y, pigData.size))
    end

    for _, blockData in ipairs(data.blocks or {}) do
        print("Block coordinates:", blockData.x, blockData.y, "Width:", blockData.width, "Height:", blockData.height, "Type:", blockData.type)
        table.insert(blocks, Block.new(blockData.x, blockData.y, blockData.width, blockData.height, blockData.type))
    end

    -- Загрузка данных о фоне
    local background = {
        imagePath = data.background and data.background.imagePath or nil,
        speedX = data.background and data.background.speedX or 0.5,
    }

    return Level.new(bird, ground, camera, pigs, blocks, background)
end

-- Метод для обработки нажатий клавиш
function Level:keypressed(key)
    if key == "r" then
        self:restart()  -- Вызываем метод перезапуска уровня
    end
end


return Level
