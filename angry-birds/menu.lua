local love = require "love"
local Menu = {}
Menu.__index = Menu

function Menu:new()
    local menu = {}
    setmetatable(menu, Menu)

    menu.options = {"Level 1", "Level 2", "Level 3"} 
    menu.selectedOption = 1
    menu.backgroundColor = {0.8, 0.8, 1}
    menu.font = love.graphics.newFont(24) 

    return menu
end

function Menu:update(dt)
    -- TODO
end

function Menu:draw()
    love.graphics.clear(self.backgroundColor)
    love.graphics.setFont(self.font) 
    love.graphics.printf("Select Level:", 0, 100, love.graphics.getWidth(), "center") 

    for i, option in ipairs(self.options) do
        if i == self.selectedOption then
            love.graphics.setColor(1, 0, 0) 
        else
            love.graphics.setColor(0, 0, 0)
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
        return self.selectedOption
    end
end

return Menu
