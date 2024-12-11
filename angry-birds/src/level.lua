-- level.lua
local Level = {}
Level.__index = Level

function Level.new(bird, ground, camera, pigs, blocks)
    local level = setmetatable({}, Level)
    level.bird = bird
    level.ground = ground
    level.camera = camera
    level.pigs = pigs or {}
    level.blocks = blocks or {}
    return level
end

-- Метод загрузки уровня
function Level:load()
    self.bird.load()
    self.ground.load()
    self.camera.initialX = self.camera.x
    self.camera.initialY = self.camera.y
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
        self.camera.resetPosition()
    end
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

    self.camera.reset()
end

return Level