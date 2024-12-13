local createLevel = {}

-- Функция для создания уровня
function createLevel.create()
    local levelData = {
        pigs = {},
        blocks = {}
    }

    local pigX, pigY = 300, 500
    local blockX, blockY = 200, 400

    -- Здесь можно создать форму ввода данных (например, через клавиши)
    -- Сначала запрашиваем координаты свиньи
    print("Enter pig coordinates (x, y): ")
    -- Примерное значение: pigX = 300, pigY = 500

    -- Далее добавляем блоки
    table.insert(levelData.pigs, {x = pigX, y = pigY, size = 30})
    table.insert(levelData.blocks, {x = blockX, y = blockY, width = 50, height = 50, type = 1})

    -- Сохраняем уровень в файл
    local jsonData = love.filesystem.write("levels/new_level.json", json.encode(levelData))

    print("Level created and saved to 'levels/new_level.json'")
end

return createLevel
