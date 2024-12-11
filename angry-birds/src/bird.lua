-- bird.lua
local bird = {x = 100, y = 400, size = 20, dx = 0, dy = 0, isLaunched = false, bounces = 0}
local gravity = 400
local slingStartX, slingStartY = 100, 400
local maxStretch = 100
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
        if bird.y + bird.size > 580 then
            bird.y = 580 - bird.size
            bird.dy = -bird.dy * bounceFactor
            bird.dx = bird.dx * friction
            bird.bounces = bird.bounces + 1

            if math.abs(bird.dy) < 10 then
                bird.dy = 0
                bird.dx = 0
                bird.isLaunched = false
            end
        end
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

        bird.dx = stretchX * launchMultiplier
        bird.dy = stretchY * launchMultiplier
        bird.isLaunched = true
    end
end

function bird.draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", bird.x, bird.y, bird.size, bird.size)

    if not bird.isLaunched then
        local mouseX, mouseY = love.mouse.getX(), love.mouse.getY()
        local stretchX = slingStartX - mouseX
        local stretchY = slingStartY - mouseY
        local stretchLength = math.sqrt(stretchX^2 + stretchY^2)

        if stretchLength > maxStretch then
            local scale = maxStretch / stretchLength
            mouseX = slingStartX - stretchX * scale
            mouseY = slingStartY - stretchY * scale
        end

        love.graphics.setColor(0.5, 0.2, 0.1)
        love.graphics.line(slingStartX, slingStartY, mouseX, mouseY)
    end
end

return bird
