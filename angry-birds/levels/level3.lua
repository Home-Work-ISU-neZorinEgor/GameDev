local Block = require "block"
local Pig = require "pig"


local Level3 = {}

function Level3:load()
    local pigs = {}
    local blocks = {}

    for i = 1, 2 do
        local pig = Pig:new(600 + (i-1) * 200, 350)
        table.insert(pigs, pig)
    end
    table.insert(blocks, Block:new(5000, 300, 70, 70))
    table.insert(blocks, Block:new(1550, 250, 70, 70))

    return pigs, blocks
end

return Level3
