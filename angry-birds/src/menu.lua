local menu = {}

local selectedLevel = 1 -- Выбранный уровень
local totalLevels = 0   -- Количество уровней
local startGameCallback = nil -- Callback для старта игры

function menu.load(levelCount, startCallback)
    totalLevels = levelCount
    startGameCallback = startCallback
end

function menu.update(dt)
    -- Здесь можно добавить анимации или другие эффекты меню
end

function menu.draw()
    love.graphics.setBackgroundColor(0.2, 0.2, 0.2)
    love.graphics.setColor(1, 1, 1)

    love.graphics.setFont(love.graphics.newFont(24))
    love.graphics.printf("Select level", 0, 100, love.graphics.getWidth(), "center")

    for i = 1, totalLevels do
        local y = 200 + (i - 1) * 40
        local text = (i == selectedLevel) and ("-> Level " .. i) or ("   level " .. i)
        love.graphics.printf(text, 0, y, love.graphics.getWidth(), "center")
    end

    love.graphics.printf("Enter `Enter` to start", 0, 400, love.graphics.getWidth(), "center")
end

function menu.keypressed(key)
    if key == "up" then
        selectedLevel = selectedLevel > 1 and selectedLevel - 1 or totalLevels
    elseif key == "down" then
        selectedLevel = selectedLevel < totalLevels and selectedLevel + 1 or 1
    elseif key == "return" or key == "enter" then
        if startGameCallback then
            startGameCallback(selectedLevel)
        end
    end
end

return menu
