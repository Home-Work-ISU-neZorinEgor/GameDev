local Block = require "block"
local Pig = require "pig"


local Level2 = {}

function Level2:load()
    local pigs = {}
    local blocks = {}

    for i = 1, 5 do
        local pig = Pig:new(400 + (i-1) * 100, 350)
        table.insert(pigs, pig)
    end
    table.insert(blocks, Block:new(300, 300, 60, 60))
    table.insert(blocks, Block:new(350, 250, 60, 60))

    return pigs, blocks
end

return Level2
