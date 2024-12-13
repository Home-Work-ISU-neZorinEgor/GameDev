local json = require("libs.json") -- Библиотека для работы с JSON
local Pig = require("pig")
local Block = require("block")

local Level = {}
Level.__index = Level

function Level.new(bird, ground, camera, pigs, blocks)
    local level = setmetatable({}, Level)
    level.bird = bird
    level.ground = ground
    level.camera = camera
    level.pigs = pigs or {}
    level.blocks = blocks or {}
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
        self.camera.setPosition(self.bird.x + self.bird.size / 2, self.bird.y + self.bird.size / 2)
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

    self.ground.draw()
    self.bird.draw()

    for _, pig in ipairs(self.pigs) do
        pig:draw()
    end

    for _, block in ipairs(self.blocks) do
        block:draw()
    end

    -- Отображаем количество уничтоженных птичек и блоков
    love.graphics.setColor(1, 1, 1)  -- Белый цвет для текста
    love.graphics.print("Pigs Destroyed: " .. self.destroyedPigs, love.graphics.getWidth() - 300, 20)
    love.graphics.print("Blocks Destroyed: " .. self.destroyedBlocks, love.graphics.getWidth() - 300, 40)

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

    return Level.new(bird, ground, camera, pigs, blocks)
end

-- Метод для обработки нажатий клавиш
function Level:keypressed(key)
    if key == "r" then
        self:restart()  -- Вызываем метод перезапуска уровня
    end
end


return Level
