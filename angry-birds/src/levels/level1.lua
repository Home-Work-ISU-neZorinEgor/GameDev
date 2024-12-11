local Pig = require("pig")
local Block = require("block")

local function loadLevel()
    local pigs = {
        Pig.new(600, 560, 30),
        Pig.new(700, 560, 30),
    }

    local blocks = {
        Block.new(300, 500, 50, 50, 1),
        Block.new(400, 500, 50, 50, 2),
        Block.new(500, 500, 50, 50, 3),
    }

    return pigs, blocks
end

return loadLevel
