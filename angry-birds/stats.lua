local Stats = {}

function Stats:draw(pigs, blocks, remainingBirds)
    love.graphics.clear(0, 0, 0)  -- Черный фон для экрана статистики
    love.graphics.setColor(1, 1, 1)

    -- Отображаем статистику
    love.graphics.print("Game Over!", 300, 100)
    love.graphics.print("Remaining Birds: " .. remainingBirds, 300, 150)
    love.graphics.print("Pigs Left: " .. #pigs, 300, 200)
    love.graphics.print("Blocks Left: " .. #blocks, 300, 250)
end

return Stats
