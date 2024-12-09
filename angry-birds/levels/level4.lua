local Block = require "block"
local Pig = require "pig"


local Level4 = {}

function Level4:load()
    local pigs = {}
    local blocks = {}

    for i = 1, 3 do
        local pig = Pig:new(500 + (i-1) * 150, 350)
        table.insert(pigs, pig)
    end
    table.insert(blocks, Block:new(400, 300, 50, 50))
    table.insert(blocks, Block:new(450, 250, 50, 50))

    return pigs, blocks
end

return Level4
