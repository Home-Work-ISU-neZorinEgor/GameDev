-- bird.lua

-- Физика:

-- 1. Гравитация: Ускоряет падение птички по вертикали (dy), добавляя постоянную силу в каждом кадре.
-- 2. Движение: Птичка движется по осям X и Y в зависимости от её скорости (dx, dy).
-- 3. Столкновение с землёй: Птичка отскакивает с уменьшенной вертикальной скоростью и замедляется по горизонтали из-за трения.
-- 4. Рогатка: Мышь тянет птичку, ограничивая натяжение, и её начальная скорость зависит от растяжения рогатки.
-- 5. Запуск: При отпускании мыши птичка получает скорость, пропорциональную растяжению.

local bird = {x = 100, y = 400, size = 20, dx = 0, dy = 0, isLaunched = false, bounces = 0, startX = 100, startY = 400}
local gravity = 700
local slingStartX, slingStartY = 200, 500  -- Сдвигаем рогатку вправо
local maxStretch = 200
local launchMultiplier = 4
local bounceFactor = 0.7
local friction = 0.98

-- Функция для загрузки птички
function bird.load()
    bird.bounces = 0
    bird.isLaunched = false
    bird.dx = 0
    bird.dy = 0
    bird.x = bird.startX
    bird.y = bird.startY
end

-- Функция обновления состояния птички
function bird.update(dt)
    if bird.isLaunched then
        -- Применяем гравитацию
        bird.dy = bird.dy + gravity * dt
        -- Обновляем позицию птички
        bird.x = bird.x + bird.dx * dt
        bird.y = bird.y + bird.dy * dt

        -- Столкновение с землёй
        if bird.y + bird.size > 880 then
            bird.y = 880 - bird.size
            bird.dy = -bird.dy * bounceFactor
            bird.dx = bird.dx * friction
            bird.bounces = bird.bounces + 1

            -- Если птичка сильно замедлилась, останавливаем её
            if math.abs(bird.dy) < 10 then
                bird.dy = 0
                bird.dx = 0
                bird.isLaunched = false
            end
        end
    else
        -- Если птичка не выстрелена, она тянется за мышкой
        local mouseX, mouseY = love.mouse.getX(), love.mouse.getY()
        local stretchX = slingStartX - mouseX
        local stretchY = slingStartY - mouseY
        local stretchLength = math.sqrt(stretchX^2 + stretchY^2)

        -- Ограничиваем натяжение
        if stretchLength > maxStretch then
            local scale = maxStretch / stretchLength
            mouseX = slingStartX - stretchX * scale
            mouseY = slingStartY - stretchY * scale
        end

        -- Рисуем две линии рогатки
        love.graphics.setColor(0.5, 0.2, 0.1)  -- Цвет рогатки
        -- Первая линия
        love.graphics.line(slingStartX, slingStartY, mouseX, mouseY)
        -- Вторая линия (отражённая)
        love.graphics.line(slingStartX * 2 - slingStartX, slingStartY, mouseX * 2 - slingStartX, mouseY)
        -- Рисуем птичку на конце натянутых линий
        love.graphics.setColor(1, 1, 0)  -- Цвет птички (жёлтый)
        love.graphics.rectangle("fill", mouseX - bird.size / 2, mouseY - bird.size / 2, bird.size, bird.size)
    end
end

-- Функция для захвата мыши и подготовки птички
function bird.mousepressed(x, y, button)
    if button == 1 and not bird.isLaunched then
        bird.x, bird.y = slingStartX, slingStartY
        bird.dx, bird.dy = 0, 0
        bird.bounces = 0
    end
end

-- Функция для запуска птички
function bird.mousereleased(x, y, button)
    if button == 1 and not bird.isLaunched then
        local stretchX = slingStartX - x
        local stretchY = slingStartY - y
        local stretchLength = math.sqrt(stretchX^2 + stretchY^2)

        if stretchLength > maxStretch then
            local scale = maxStretch / stretchLength
            stretchX = stretchX * scale
            stretchY = stretchY * scale
        end

        -- Устанавливаем начальную скорость (dx, dy) в зависимости от растяжения рогатки
        bird.dx = stretchX * launchMultiplier
        bird.dy = stretchY * launchMultiplier
        bird.isLaunched = true
    end
end

-- Функция для отрисовки птички
function bird.draw()
    love.graphics.setColor(1, 1, 0)  -- Цвет птички (жёлтый)

    if bird.isLaunched then
        -- Если птичка выстрелена, рисуем её в текущих координатах
        love.graphics.rectangle("fill", bird.x, bird.y, bird.size, bird.size)
    else
        -- Если птичка не выстрелена, рисуем её на конце натянутых линий
        local mouseX, mouseY = love.mouse.getX(), love.mouse.getY()
        local stretchX = slingStartX - mouseX
        local stretchY = slingStartY - mouseY
        local stretchLength = math.sqrt(stretchX^2 + stretchY^2)

        -- Ограничиваем натяжение
        if stretchLength > maxStretch then
            local scale = maxStretch / stretchLength
            mouseX = slingStartX - stretchX * scale
            mouseY = slingStartY - stretchY * scale
        end

        -- Устанавливаем ширину линий
        love.graphics.setLineWidth(4)  -- Сделаем линии шире (ширина линии = 8 пикселей)
        -- Рисуем две линии рогатки
        love.graphics.setColor(0.5, 0.2, 0.1)  -- Цвет рогатки
        -- Первая линия
        love.graphics.line(slingStartX, slingStartY, mouseX, mouseY)
        -- Вторая линия (отражённая)
        love.graphics.line(slingStartX + 100, slingStartY, mouseX, mouseY)
        -- Рисуем птичку
        love.graphics.setColor(1, 1, 0)  -- Цвет птички (жёлтый)
        love.graphics.rectangle("fill", mouseX - bird.size / 2, mouseY - bird.size / 2, bird.size, bird.size)
    end
end


return bird