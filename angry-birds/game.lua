local love = require "love"
local Game = {}
local Bird = require "bird"
local Slingshot = require "slingshot"
local config = require "config"
local Menu = require "menu"
Game.__index = Game

function Game:new()
    local game = {}
    setmetatable(game, Game)

    game.currentState = "menu" -- Начальное состояние - меню
    game.menu = Menu:new()
    game.bird = nil
    game.pigs = {}
    game.slingshot = nil
    game.gravity = config.gravity
    game.isBirdFlying = false
    game.launchForce = config.launchForce
    game.cameraOffsetX = 0
    game.backgroundColor = {1, 1, 1}
    game.backgroundImage = love.graphics.newImage(config.images.background)
    game.blocks = {}

    return game
end

function Game:startLevel(level)
    self.currentState = "game" -- Переключаемся на игровое состояние
    self.bird = Bird:new(Slingshot:new(150, 250))
    self.slingshot = Slingshot:new(150, 250)

    -- Загружаем уровень из файла
    local levelModule = require("levels.level" .. level)
    self.pigs, self.blocks = levelModule:load() -- Загружаем свиней и блоки
end


function Game:update(dt)
    if self.currentState == "game" then
        if self.isBirdFlying then
            self.bird:update(dt, self.gravity, true)
            self.cameraOffsetX = self.bird.x - 200
            self.isBirdFlying = self.bird:checkGroundCollision(400)

            for i = #self.pigs, 1, -1 do
                local pig = self.pigs[i]
                local dx = self.bird.x - pig.x
                local dy = self.bird.y - pig.y
                local distance = math.sqrt(dx * dx + dy * dy)

                if distance < self.bird.radius + pig.radius then
                    table.remove(self.pigs, i)
                end
            end

            for _, block in ipairs(self.blocks) do
                block:update(dt, self.bird)
            end
        end
    elseif self.currentState == "menu" then
        self.menu:update(dt)
    end
end

function Game:draw()
    if self.currentState == "game" then
        love.graphics.clear(self.backgroundColor)
        love.graphics.draw(self.backgroundImage, 0, 0)
        love.graphics.translate(-self.cameraOffsetX, 0)
        
        love.graphics.setColor(0.5, 0.3, 0)
        love.graphics.rectangle("fill", self.slingshot.x - 5, self.slingshot.y, 10, 100)

        if self.bird.isHeld then
            love.graphics.setColor(0, 0, 0)
            love.graphics.line(self.slingshot.x, self.slingshot.y, self.bird.x, self.bird.y)
        end

        self.bird:draw()

        for _, pig in ipairs(self.pigs) do
            pig:draw()
        end

        for _, block in ipairs(self.blocks) do
            block:draw()
        end

        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.rectangle("fill", 0, 400, love.graphics.getWidth() * 2, 50)
    elseif self.currentState == "menu" then
        self.menu:draw()
    end
end

function Game:mousepressed(x, y, button)
    if self.currentState == "game" then
        if button == 1 and self.bird.isHeld then
            local dx = self.slingshot.x - self.bird.x
            local dy = self.slingshot.y - self.bird.y
            local distance = math.sqrt(dx * dx + dy * dy)

            self.bird.vx = (dx / distance) * self.launchForce
            self.bird.vy = (dy / distance) * self.launchForce
            self.bird.isHeld = false
            self.isBirdFlying = true
        end
    elseif self.currentState == "menu" then
        local selectedLevel = self.menu:keypressed("return")
        if selectedLevel then
            self:startLevel(selectedLevel) -- Запускаем выбранный уровень
        end
    end
end

function Game:mousemoved(x, y, dx, dy)
    if self.currentState == "game" and self.bird.isHeld then
        local dx = x - self.slingshot.x
        local dy = y - self.slingshot.y
        local distance = math.sqrt(dx * dx + dy * dy)

        if distance > self.slingshot.maxStretch then
            local ratio = self.slingshot.maxStretch / distance
            self.bird.x = self.slingshot.x + dx * ratio
            self.bird.y = self.slingshot.y + dy * ratio
        else
            self.bird.x = x
            self.bird.y = y
        end
    end
end

function Game:keypressed(key)
    if self.currentState == "game" then
        if key == "r" then
            self:startLevel(1) -- Перезапускаем первый уровень
        end
    elseif self.currentState == "menu" then
        self.menu:keypressed(key) -- Обрабатываем нажатия клавиш в меню
    end
end

return Game
