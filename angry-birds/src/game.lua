local bird = require("bird")
local ground = require("ground")
local camera = require("camera")
local Level = require("level")
local menu = require("menu")

local game = {}
local levels = {}
local currentLevelIndex = 1
local currentLevel = nil
local state = "menu" -- "menu" или "game"

-- Загрузить все уровни
local function loadLevels()
    local levelFiles = love.filesystem.getDirectoryItems("levels")
    for _, file in ipairs(levelFiles) do
        if file:match("%.json$") then
            table.insert(levels, "levels/" .. file)
        end
    end
end

-- Загрузить уровень
local function loadLevel(index)
    if index <= #levels then
        currentLevelIndex = index
        local fileName = levels[index]
        local jsonData = love.filesystem.read(fileName)
        currentLevel = Level.fromJson(jsonData, bird, ground, camera)
        currentLevel:load()
        state = "game"
    else
        currentLevel = nil
        state = "menu"
    end
end

function game.load()
    bird.load()
    ground.load()
    camera.initialX = camera.x
    camera.initialY = camera.y

    -- Загрузить все уровни
    loadLevels()

    -- Инициализировать меню
    menu.load(#levels, function(level)
        loadLevel(level)
    end)
end

function game.update(dt)
    if state == "menu" then
        menu.update(dt)
    elseif state == "game" and currentLevel then
        currentLevel:update(dt)
    end
end

function game.keypressed(key)
    if key == "r" then
        if currentLevel then
            currentLevel:reset()  -- Перезапустить текущий уровень
        end
    end

    if state == "menu" then
        menu.keypressed(key)
    elseif state == "game" then
        if key == "escape" then
            state = "menu"
        end
    end
end


function game.mousepressed(x, y, button)
    if state == "game" and currentLevel then
        currentLevel:mousepressed(x, y, button)
    end
end

function game.mousereleased(x, y, button)
    if state == "game" and currentLevel then
        currentLevel:mousereleased(x, y, button)
    end
end

function game.draw()
    if state == "menu" then
        menu.draw()
    elseif state == "game" and currentLevel then
        currentLevel:draw()
    end
end

return game