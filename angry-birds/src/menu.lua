local menu = {}
local editor = require("editor")  -- Подключаем экран редактора

local state = "main"  -- "main" - главное меню, "levels" - меню выбора уровня, "editor" - экран редактора
local selectedLevel = 1 -- Выбранный уровень
local totalLevels = 0   -- Количество уровней
local startGameCallback = nil -- Callback для старта игры

function menu.load(levelCount, startCallback)
    totalLevels = levelCount
    startGameCallback = startCallback
end

function menu.update(dt)
    if state == "editor" then
        editor.update(dt)  -- Обновляем редактор
    end
end

function menu.draw()
    love.graphics.setColor(1, 1, 1)  -- Сброс цвета для отрисовки

    if state == "main" then
        love.graphics.setBackgroundColor(0.2, 0.2, 0.2)
        love.graphics.setFont(love.graphics.newFont(24))
        love.graphics.printf("Main Menu", 0, 100, love.graphics.getWidth(), "center")
        love.graphics.printf("1. Levels", 0, 250, love.graphics.getWidth(), "center")
        love.graphics.printf("2. Create Level", 0, 300, love.graphics.getWidth(), "center")
        love.graphics.printf("Press Enter to Select", 0, 400, love.graphics.getWidth(), "center")
    elseif state == "levels" then
        love.graphics.setBackgroundColor(0.2, 0.2, 0.2)
        love.graphics.setFont(love.graphics.newFont(24))
        love.graphics.printf("Select level", 0, 100, love.graphics.getWidth(), "center")

        for i = 1, totalLevels do
            local y = 200 + (i - 1) * 40
            local text = (i == selectedLevel) and ("-> Level " .. i) or ("   Level " .. i)
            love.graphics.printf(text, 0, y, love.graphics.getWidth(), "center")
        end

        love.graphics.printf("Press Enter to Start", 0, 400, love.graphics.getWidth(), "center")
    elseif state == "editor" then
        editor.draw()
    end
end

function menu.keypressed(key)
    if state == "main" then
        if key == "1" then
            -- Переход к игре
            state = "levels"  -- Переход в меню уровней
        elseif key == "2" then
            -- Переход в редактор уровней
            state = "editor"  -- Переход в экран редактора
            editor.load()  -- Загружаем редактор
        end
    elseif state == "levels" then
        if key == "up" then
            selectedLevel = selectedLevel > 1 and selectedLevel - 1 or totalLevels
        elseif key == "down" then
            selectedLevel = selectedLevel < totalLevels and selectedLevel + 1 or 1
        elseif key == "return" or key == "enter" then
            if startGameCallback then
                startGameCallback(selectedLevel)  -- Начинаем игру с выбранным уровнем
            end
        elseif key == "escape" then
            state = "main"  -- Возвращаемся в главное меню
        end
    elseif state == "editor" then
        editor.keypressed(key)  -- Передаем клавишу в редактор
        if key == "escape" then
            state = "main"  -- Возвращаемся в главное меню
        end
    end
end

function menu.mousepressed(x, y, button, istouch, presses)
    if state == "editor" then
        print("Mouse button pressed at: (" .. x .. ", " .. y .. ")")
        editor.mousepressed(x, y, button, istouch, presses)  -- Передаем клик в редактор
    end
end

function menu.mousemoved(x, y, dx, dy, istouch)
    if state == "editor" then
        print("Mouse moved to: (" .. x .. ", " .. y .. ")")
        editor.mousemoved(x, y, dx, dy, istouch)  -- Передаем движение мыши в редактор
    end
end

function menu.mousereleased(x, y, button, istouch, presses)
    if state == "editor" then
        print("Mouse button released at: (" .. x .. ", " .. y .. ")")
        editor.mousereleased(x, y, button, istouch, presses)  -- Передаем отпускание кнопки в редактор
    end
end

return menu
