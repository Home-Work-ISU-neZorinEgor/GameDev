local love = require "love"
local Menu = {}
Menu.__index = Menu

local config = require "config"  -- Подключаем конфиг с путями

function Menu:new()
    local menu = {}
    setmetatable(menu, Menu)

    menu.options = {"Level 1", "Level 2", "Level 3", "Level 4"} 
    menu.selectedOption = 1
    menu.backgroundColor = {0.8, 0.8, 1}
    menu.font = love.graphics.newFont(24) 

    -- Загружаем фоновое изображение
    menu.backgroundImage = love.graphics.newImage(config.images.menuBackground)

    -- Загружаем звук
    menu.levelSwitchSound = love.audio.newSource(config.sounds.levelSwitch, "static")

    return menu
end

function Menu:update(dt)
    -- Здесь можно добавить логику для обновления состояния меню, если потребуется
end

function Menu:draw()
    -- Отображаем фоновое изображение меню
    love.graphics.draw(self.backgroundImage, 0, 0)

    -- Отображаем текст
    love.graphics.setFont(self.font) 
    love.graphics.printf("Select Level:", 0, 100, love.graphics.getWidth(), "center") 

    -- Отображаем варианты выбора уровня
    for i, option in ipairs(self.options) do
        if i == self.selectedOption then
            love.graphics.setColor(1, 0, 0)  -- Выбранный уровень красным
        else
            love.graphics.setColor(0, 0, 0)  -- Остальные уровни черным
        end
        love.graphics.printf(option, 0, 150 + (i - 1) * 40, love.graphics.getWidth(), "center")
    end
end

function Menu:keypressed(key)
    if key == "down" then
        self.selectedOption = math.min(#self.options, self.selectedOption + 1)
    elseif key == "up" then
        self.selectedOption = math.max(1, self.selectedOption - 1)
    elseif key == "return" then
        self.levelSwitchSound:play()  -- Играем звук при выборе уровня
        return self.selectedOption
    end
end

return Menu
