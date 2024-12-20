local lfs = require("lfs")

local editor = {}

local mouseWasDown = false                                                          -- Флаг, отслеживающий, была ли кнопка мыши зажата
local isDragging = false                                                            -- Флаг, указывающий, перетаскиваем ли мы блок
local draggedBlock = nil                                                            -- Перемещаемый блок
local draggedCopy = nil                                                             -- Копия блока
local blocks = {                                                                    -- Массив блоков
    {x = 20, y = 20, width = 50, height = 50, color = {0.4, 0.8, 0.4}, type = 1 },  -- Целый блок зеленый [3/3]
    {x = 80, y = 20, width = 50, height = 50, color = {1, 1, 0}, type = 2 },        -- Блок средней разрушенности [2/3]
    {x = 140, y = 20, width = 50, height = 50, color = {1, 0, 0}, type = 3 },       -- Почти сломанный блок [1/3]
    {x = 200, y = 20, width = 30, height = 30, color = {0, 1, 0}, type = 4 }        -- Свинка
}

local newBlocks = {}                                                                -- Массив для хранения только новых блоков
local dropZone = {x = 20, y = 80, width = 1880, height = 800}                       -- Зона, в которую можно помещать блоки
local saveButton = {x = 1700, y = 890, width = 200, height = 50}                    -- Позиция кнопки сохранения
local pigCount = 3                                                                  -- Начальное количество птичек
local plusButton = {x = 1600, y = 20, width = 50, height = 50}                     -- Кнопка "+"
local minusButton = {x = 1540, y = 20, width = 50, height = 50}                    -- Кнопка "-"

function editor.load()
end

function editor.update(dt)
    local mouseX, mouseY = love.mouse.getPosition()                                 -- Координаты мыши

    -- Обработка нажатия кнопки мыши
    if love.mouse.isDown(1) then
        if not mouseWasDown then
            -- Проверяем, попала ли мышь в область кнопки сохранения
            if mouseX >= saveButton.x and mouseX <= saveButton.x + saveButton.width and mouseY >= saveButton.y and mouseY <= saveButton.y + saveButton.height then
                -- Сохраняем данные в файл
                saveToFile()
            end

            -- Проверяем, попала ли мышь в область кнопок "+" или "-"
            if mouseX >= plusButton.x and mouseX <= plusButton.x + plusButton.width and mouseY >= plusButton.y and mouseY <= plusButton.y + plusButton.height then
                pigCount = pigCount + 1  -- Увеличиваем количество птичек
            elseif mouseX >= minusButton.x and mouseX <= minusButton.x + minusButton.width and mouseY >= minusButton.y and mouseY <= minusButton.y + minusButton.height then
                pigCount = math.max(1, pigCount - 1)  -- Уменьшаем количество птичек (не меньше 1)
            end

            -- Проверяем, попала ли мышь в область одного из блоков
            for i, block in ipairs(blocks) do
                if mouseX >= block.x and mouseX <= block.x + block.width and mouseY >= block.y and mouseY <= block.y + block.height then
                    -- Если это исходный блок (изначальный, а не новый), создаем новый блок
                    if i <= 4 then
                        -- Создаем новый блок как копию исходного и сохраняем его цвет
                        local newBlock = {
                            x = block.x + 70,  -- Смещение для нового блока
                            y = block.y + 70,
                            width = 50,
                            height = 50,
                            color = {block.color[1], block.color[2], block.color[3]},  -- Используем цвет родителя
                            type = block.type  -- Новый блок будет иметь тот же тип
                        }
                        if block.type == 4 then
                            newBlock.height = 30
                            newBlock.width = 30
                        end
                        table.insert(blocks, newBlock)  -- Добавляем новый блок в список
                        table.insert(newBlocks, newBlock)  -- Добавляем новый блок в список новых блоков
                        draggedBlock = newBlock  -- Начинаем перетаскивать новый блок
                    else
                        -- Если это новый блок, начинаем его перетаскивание
                        isDragging = true
                        draggedBlock = block  -- Запоминаем перетаскиваемый блок
                        originalPosition = {x = draggedBlock.x, y = draggedBlock.y}  -- Сохраняем исходную позицию
                        draggedCopy = {x = draggedBlock.x, y = draggedBlock.y, width = draggedBlock.width, height = draggedBlock.height, color = draggedBlock.color, type = draggedBlock.type}
                    end
                    break
                end
            end

            mouseWasDown = true  -- Устанавливаем флаг, что кнопка была зажата
        end
    else
        if mouseWasDown then
            -- Перемещаем блок в новую позицию (ограниченную зоной)
            if isDragging and draggedCopy then
                draggedBlock.x = math.max(dropZone.x, math.min(draggedCopy.x, dropZone.x + dropZone.width - draggedBlock.width))
                draggedBlock.y = math.max(dropZone.y, math.min(draggedCopy.y, dropZone.y + dropZone.height - draggedBlock.height))
            end
            mouseWasDown = false  -- Сбрасываем флаг, что кнопка не зажата
            isDragging = false  -- Заканчиваем перетаскивание
            draggedBlock = nil  -- Сбрасываем перетаскиваемый блок
            draggedCopy = nil  -- Сбрасываем копию блока
            originalPosition = nil  -- Сбрасываем исходную позицию
        end
    end

    -- Если перетаскиваем копию блока, обновляем его положение
    if isDragging and draggedCopy then
        draggedCopy.x = mouseX - draggedCopy.width / 2  -- Центрируем копию блока на курсоре
        draggedCopy.y = mouseY - draggedCopy.height / 2
    end
end

-- Функция для получения следующего имени файла
local function getNextLevelFileName(directory)
    local lastLevel = 0

    for file in lfs.dir(directory) do
        -- Проверяем, соответствует ли имя файла шаблону level{число}.json
        local levelNumber = file:match("level(%d+)%.json")
        if levelNumber then
            levelNumber = tonumber(levelNumber)
            if levelNumber and levelNumber > lastLevel then
                lastLevel = levelNumber
            end
        end
    end

    -- Возвращаем новое имя файла
    return string.format("level%d.json", lastLevel + 1)
end

-- Функция для сохранения данных в файл
function saveToFile()
    local output = '{'
    output = output .. '"pigs": ['

    -- Проходим по новым блокам и добавляем в pigs, если тип блока не 1, 2 или 3
    for i, block in ipairs(newBlocks) do
        if block.type ~= 1 and block.type ~= 2 and block.type ~= 3 then
            output = output .. string.format(
                '{ "x": %d, "y": %d, "size": %d }',
                block.x, block.y, block.width
            )
            if i < #newBlocks then
                output = output .. ", "
            end
        end
    end
    output = output .. '],'

    output = output .. '"blocks": ['
    -- Теперь добавляем только те блоки, которые имеют тип 1, 2 или 3
    for i, block in ipairs(blocks) do
        if i >= 4 and (block.type == 1 or block.type == 2 or block.type == 3) then
            output = output .. string.format(
                '{ "x": %d, "y": %d, "width": %d, "height": %d, "type": %d }',
                block.x, block.y, block.width, block.height, block.type
            )
            if i < #blocks then
                output = output .. ", "
            end
        end
    end
    
    output = output .. "]"
    output = output .. ', "background": {"imagePath": "/asserts/images/parallax.png", "speedX": 0.1}'
    output = output .. ', "birdsCount": ' .. pigCount .. '}'


    -- Генерация имени нового файла
    local directory = "src/levels"
    local newFileName = getNextLevelFileName(directory)
    local filePath = directory .. "/" .. newFileName

    -- Сохраняем в файл
    local file = io.open(filePath, "w")
    if file then
        file:write(output)
        file:close()
        print("Уровень сохранён в файл:", filePath)
    else
        print("Не удалось открыть файл для записи.")
    end
end

function editor.draw()
    -- Отрисовываем зону для кубиков
    love.graphics.setColor(0.8, 0.8, 0.8)  -- Светло-серый цвет для зоны
    love.graphics.rectangle("line", dropZone.x, dropZone.y, dropZone.width, dropZone.height)  -- Рисуем прямоугольник зоны

    -- Отрисовываем каждый блок с его цветом
    for _, block in ipairs(blocks) do
        love.graphics.setColor(block.color)  -- Устанавливаем цвет блока
        love.graphics.rectangle("fill", block.x, block.y, block.width, block.height)  -- Рисуем блок
    end

    -- Отрисовываем кнопку сохранения
    love.graphics.setColor(0.5, 0.5, 0.5)  -- Зеленый цвет для кнопки
    love.graphics.rectangle("fill", saveButton.x, saveButton.y, saveButton.width, saveButton.height)  -- Рисуем кнопку
    love.graphics.setColor(1, 1, 1)  -- Черный цвет для текста
    love.graphics.print("Save level", saveButton.x + 40, saveButton.y + 10)  -- Текст на кнопке

    -- Отрисовываем кнопки "+" и "-"
    love.graphics.setColor(1, 0, 0)  -- Зеленый для "+" и "-"
    love.graphics.rectangle("fill", minusButton.x, minusButton.y, minusButton.width, minusButton.height)  -- Кнопка "-"
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", plusButton.x, plusButton.y, plusButton.width, plusButton.height)  -- Кнопка "+"
    love.graphics.setColor(1, 1, 1)  -- Белый цвет для текста
    love.graphics.print("-", minusButton.x + 20, minusButton.y + 10)  -- Текст на кнопке "-"
    love.graphics.print("+", plusButton.x + 20, plusButton.y + 10)  -- Текст на кнопке "+"

    -- Отображаем количество птичек
    love.graphics.print("Birds: " .. pigCount, 1400, 20)

    -- Если перетаскиваем, рисуем копию блока
    if draggedCopy then
        love.graphics.setColor(draggedCopy.color)  -- Устанавливаем цвет копии
        love.graphics.rectangle("fill", draggedCopy.x, draggedCopy.y, draggedCopy.width, draggedCopy.height)  -- Рисуем копию блока
    end
end

function editor.keypressed(key)
    if key == "escape" then
        return true  -- Вернуться в меню
    end
end

return editor
