-- bird.lua

-- Физика:

-- 1. Гравитация: Ускоряет падение птички по вертикали (dy), добавляя постоянную силу в каждом кадре.
-- 2. Движение: Птичка движется по осям X и Y в зависимости от её скорости (dx, dy).
-- 3. Столкновение с землёй: Птичка отскакивает с уменьшенной вертикальной скоростью и замедляется по горизонтали из-за трения.
-- 4. Рогатка: Мышь тянет птичку, ограничивая натяжение, и её начальная скорость зависит от растяжения рогатки.
-- 5. Запуск: При отпускании мыши птичка получает скорость, пропорциональную растяжению.

local bird = {x = 100, y = 400, size = 20, dx = 0, dy = 0, isLaunched = false, bounces = 0, startX = 100, startY = 400}
local gravity = 500
local slingStartX, slingStartY = 200, 500  -- Сдвигаем рогатку вправо
local maxStretch = 200
local launchMultiplier = 4
local bounceFactor = 0.7
local friction = 0.98

function bird.load()
    bird.bounces = 0
end

function bird.update(dt)
    if bird.isLaunched then
        bird.dy = bird.dy + gravity * dt
        bird.x = bird.x + bird.dx * dt
        bird.y = bird.y + bird.dy * dt

        -- Столкновение с землей
        if bird.y + bird.size > 900 then
            bird.y = 900 - bird.size
            bird.dy = -bird.dy * bounceFactor
            bird.dx = bird.dx * friction
            bird.bounces = bird.bounces + 1

            if math.abs(bird.dy) < 10 then
                bird.dy = 0
                bird.dx = 0
                bird.isLaunched = false
            end
        end
    else
        -- Если птичка не выстрелена, она должна двигаться к месту, где была отпущена
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

        -- Рисуем только одну линию рогатки
        love.graphics.setColor(0.5, 0.2, 0.1)  -- Цвет рогатки
        love.graphics.line(slingStartX, slingStartY, mouseX, mouseY)

        -- Рисуем птичку на конце натянутой линии
        love.graphics.setColor(1, 1, 0)  -- Цвет птички (жёлтый)
        love.graphics.rectangle("fill", mouseX - bird.size / 2, mouseY - bird.size / 2, bird.size, bird.size)
    end
end

function bird.mousepressed(x, y, button)
    if button == 1 and not bird.isLaunched then
        bird.x, bird.y = slingStartX, slingStartY
        bird.dx, bird.dy = 0, 0
        bird.bounces = 0
    end
end

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

function bird.draw()
    love.graphics.setColor(1, 1, 0)  -- Цвет птички (жёлтый)

    if bird.isLaunched then
        -- Если птичка выстрелена, рисуем её в текущих координатах
        love.graphics.rectangle("fill", bird.x, bird.y, bird.size, bird.size)
    else
        -- Если птичка не выстрелена, рисуем её на конце натянутой линии рогатки
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

        -- Рисуем только одну линию рогатки
        love.graphics.setColor(0.5, 0.2, 0.1)  -- Цвет рогатки
        love.graphics.line(slingStartX, slingStartY, mouseX, mouseY)

        -- Рисуем птичку на конце натянутой линии рогатки
        love.graphics.setColor(1, 1, 0)  -- Цвет птички (жёлтый)
        love.graphics.rectangle("fill", mouseX - bird.size / 2, mouseY - bird.size / 2, bird.size, bird.size)
    end
end

return bird
