-- camera.lua
local camera = {
    x = 0,
    y = 0,
    scale = 1,
    width = 800,
    height = 600,
    initialX = 0,
    initialY = 0,
    isFollowing = false  -- Флаг отслеживания
}

-- Функция для установки позиции камеры
function camera.setPosition(x, y)
    camera.x = x - camera.width / 2
    camera.y = y - camera.height / 2
end

-- Включение/выключение режима следования
function camera.setFollowMode(enabled)
    camera.isFollowing = enabled
end

-- Применение трансформации камеры
function camera.apply()
    love.graphics.push()
    love.graphics.translate(-camera.x, -camera.y)
    love.graphics.scale(camera.scale)
end

-- Сброс трансформации
function camera.reset()
    love.graphics.pop()
end

-- Возвращение камеры в начальное положение
function camera.resetPosition()
    camera.x = camera.initialX
    camera.y = camera.initialY
end

return camera
