local editor = {}

local mouseWasDown = false  -- Флаг, отслеживающий, была ли кнопка мыши зажата
local isDragging = false  -- Флаг, указывающий, перетаскиваем ли мы блок
local draggedBlock = nil  -- Перемещаемый блок
local originalPosition = nil  -- Хранит исходное положение блока
local blocks = {  -- Массив блоков
    {x = 100, y = 100, width = 60, height = 60, color = {1, 0, 0}},  -- Первый блок (красный)
    {x = 100, y = 180, width = 60, height = 60, color = {0, 1, 0}},  -- Второй блок (зеленый)
    {x = 100, y = 260, width = 60, height = 60, color = {0, 0, 1}},  -- Третий блок (синий)
    {x = 100, y = 340, width = 60, height = 60, color = {1, 1, 0}}   -- Четвертый блок (желтый)
}

function editor.load()
    print("Editor loaded")  -- Принт при загрузке редактора
end

function editor.update(dt)
    local mouseX, mouseY = love.mouse.getPosition()  -- Получаем координаты мыши

    -- Проверяем, зажата ли левая кнопка мыши
    if love.mouse.isDown(1) then
        if not mouseWasDown then
            -- Проверяем, попала ли мышь в область одного из блоков
            for i, block in ipairs(blocks) do
                if mouseX >= block.x and mouseX <= block.x + block.width and mouseY >= block.y and mouseY <= block.y + block.height then
                    isDragging = true  -- Начинаем перетаскивание
                    draggedBlock = block  -- Запоминаем перетаскиваемый блок
                    originalPosition = {x = draggedBlock.x, y = draggedBlock.y}  -- Сохраняем исходную позицию
                    print("Started dragging block #" .. i)  -- Принт при начале перетаскивания
                    break
                end
            end

            -- Если кликнули не по блоку, создаем новый
            if not draggedBlock then
                local newBlock = {
                    x = mouseX - 30,  -- Центрируем новый блок
                    y = mouseY - 30,
                    width = 60,
                    height = 60,
                    color = {math.random(), math.random(), math.random()}  -- Новый случайный цвет
                }
                table.insert(blocks, newBlock)  -- Добавляем новый блок в список
                draggedBlock = newBlock  -- Начинаем перетаскивать новый блок
                print("Started dragging new block")  -- Принт при создании нового блока
            end

            mouseWasDown = true  -- Устанавливаем флаг, что кнопка была зажата
        end
    else
        if mouseWasDown then
            if isDragging then
                print("Stopped dragging")  -- Принт при отпускании кнопки
                -- Печатаем, какой блок отпустили и на каких координатах
                print("Released block at coordinates: x = " .. draggedBlock.x .. ", y = " .. draggedBlock.y)
                
                -- Создаем новый блок на месте старого
                if originalPosition then
                    local newBlock = {
                        x = draggedBlock.x,  -- Позиция нового блока на месте старого
                        y = draggedBlock.y,
                        width = 60,
                        height = 60,
                        color = {math.random(), math.random(), math.random()}  -- Новый случайный цвет
                    }
                    table.insert(blocks, newBlock)  -- Добавляем новый блок в список
                    print("Created new block at position: x = " .. draggedBlock.x .. ", y = " .. draggedBlock.y)
                end
            end
            mouseWasDown = false  -- Сбрасываем флаг, что кнопка не зажата
            isDragging = false  -- Заканчиваем перетаскивание
            draggedBlock = nil  -- Сбрасываем перетаскиваемый блок
            originalPosition = nil  -- Сбрасываем исходную позицию
        end
    end

    -- Если перетаскиваем блок, обновляем его положение
    if isDragging and draggedBlock then
        draggedBlock.x = mouseX - draggedBlock.width / 2  -- Центрируем блок на курсоре
        draggedBlock.y = mouseY - draggedBlock.height / 2
    end
end

function editor.draw()
    love.graphics.setBackgroundColor(1, 1, 1)  -- Белый экран

    -- Отрисовываем каждый блок с его цветом
    for _, block in ipairs(blocks) do
        love.graphics.setColor(block.color)  -- Устанавливаем цвет блока
        love.graphics.rectangle("fill", block.x, block.y, block.width, block.height)  -- Рисуем блок
    end
end

function editor.keypressed(key)
    print("Key pressed in editor: " .. key)  -- Принт при нажатии клавиши
    if key == "escape" then
        return true  -- Вернуться в меню
    end
end

return editor
